require 'spec_helper'

module Rufo
  RSpec.describe Group do
    BREAK_NOTE_TEXT = "\n*\n"
    BREAK_NOTE = GroupIfBreak.new(BREAK_NOTE_TEXT, "")

    it "breaks at line length 10" do
      subject = described_class.new(:group, indent: 0, line_length: 10)
      subject << "hello"
      subject << " "
      subject << BREAK_NOTE
      subject << "darkness"
      subject.process

      expect(subject.to_s).to include BREAK_NOTE_TEXT
    end

    it "breaks exactly at line length" do
      subject = described_class.new(:group, indent: 0, line_length: 10)
      subject << "1234567890"
      subject << BREAK_NOTE

      subject.process
      expect(subject.to_s).to_not include BREAK_NOTE_TEXT

      subject << "1"
      subject.process

      expect(subject.to_s).to include BREAK_NOTE_TEXT
    end

    it "breaks at appropriate points for nested groups" do
      inner = described_class.new(:inner, indent: 0, line_length: 10)
      outer = described_class.new(:outer, indent: 0, line_length: 10)

      outer << "12345"
      outer << BREAK_NOTE
      outer << "678901"
      outer << "\n"

      inner << "12345"
      inner << BREAK_NOTE
      inner << "67890"

      outer << inner

      outer.process

      expect(inner.to_s).to_not include BREAK_NOTE_TEXT
      expect(outer.to_s).to include BREAK_NOTE_TEXT
    end

    it "if an inner group needs to break, so does the outer" do
      inner = described_class.new(:inner, indent: 0, line_length: 3)
      outer = described_class.new(:outer, indent: 0, line_length: 3)

      inner << "1234"
      inner << BREAK_NOTE
      inner << "2"

      outer << inner

      outer << "10"
      outer << BREAK_NOTE

      outer.process

      expect(outer.to_s).to eq "1234#{BREAK_NOTE_TEXT}210#{BREAK_NOTE_TEXT}"
    end

    it "if an inner group forces a break, outer breaks" do
      inner = described_class.new(:inner, indent: 0, line_length: 100)
      outer = described_class.new(:outer, indent: 0, line_length: 100)

      inner << "1"
      inner << BREAKING
      inner << BREAK_NOTE
      inner << "2"
      outer << inner
      outer << "10"
      outer << BREAK_NOTE

      outer.process

      expect(outer.to_s).to include "1#{BREAK_NOTE_TEXT}2"
      expect(outer.to_s).to include "1#{BREAK_NOTE_TEXT}210#{BREAK_NOTE_TEXT}"
    end

    it "breaks outer groups first" do
      inner = described_class.new(:inner, indent: 0, line_length: 10)
      outer = described_class.new(:outer, indent: 0, line_length: 10)

      outer << "12345"
      outer << GroupIfBreak.new("\n", "")
      inner << "inner"
      inner << BREAK_NOTE
      inner << "group"
      outer << inner
      outer << GroupIfBreak.new("\n", "")
      outer << "67890"

      outer.process

      expect(outer.to_s).to eq "12345\ninnergroup\n67890"
      expect(outer.to_s.lines.count).to eq 3
    end

    it "can break inner and outer groups" do
      inner = described_class.new(:inner, indent: 0, line_length: 10)
      outer = described_class.new(:outer, indent: 0, line_length: 10)

      outer << "12345"
      outer << SOFTLINE

      inner << "1234567890"
      inner << BREAK_NOTE
      inner << "1"

      outer << inner
      outer << SOFTLINE
      outer << "67890"

      outer.process

      expect(outer.to_s.lines.count).to eq 5
      expect(outer.to_s).to include BREAK_NOTE_TEXT
    end

    it "only breaks if breaking actually uses less column" do
      group = described_class.new(:group, indent: 0, line_length: 1)

      group << "x"
      group << SOFTLINE
      group << GroupIndent.new(2)
      group << "."
      group << "y"

      group.process

      expect(group.to_s).to eq "x.y"
    end

    describe "indent" do
      it "indents correctly" do
        group = described_class.new(:group, indent: 0, line_length: 10)

        group << "\n"
        group << GroupIndent.new(4)
        group << "hello!"
        group << "\n"
        group << "this should be 4 deep"
        group << GroupIndent.new(2)
        group << "\n"
        group << "2 deep"

        group.process

        expect(group.to_s).to include "\n    hello!"
        expect(group.to_s).to include "\n    this should be 4 deep"
        expect(group.to_s).to include "\n  2 deep"
      end
    end

    describe "dot calls" do
      it "complex scenario" do
        group = described_class.new(:group, indent: 0, line_length: 9)

        group << "foo"
        group << GroupIndent.new(2)
        group << SOFTLINE
        group << "."
        group << "bar"

        inner = described_class.new(:inner, indent: 2, line_length: 9)
        group << inner

        inner << "("
        inner << SOFTLINE
        inner << GroupIndent.new(4)
        inner << "1"
        inner << GroupIndent.new(2)
        inner << GroupIfBreak.new(",", "")
        inner << SOFTLINE
        inner << ")"

        group.process

        expect(group.to_s).to eq "foo\n  .bar(1)"
      end
    end
  end
end
