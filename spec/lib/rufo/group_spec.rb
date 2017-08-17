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

    describe "trailing" do
      it "adds a space if it's appended" do
        group = described_class.new(:group, indent: 0, line_length: 10)

        group << "text"
        group << GroupTrailing.new("# comment")

        group.process

        expect(group.to_s).to eq "text # comment"
      end

      it "adds no space if it's on it's own line" do
        group = described_class.new(:group, indent: 0, line_length: 10)

        group << "text"
        group << "\n"
        group << GroupTrailing.new("# comment")

        group.process

        expect(group.to_s).to eq "text\n# comment"
      end

      it "adds no space if it's the first token" do
        group = described_class.new(:group, indent: 0, line_length: 10)

        group << GroupTrailing.new("# comment")

        group.process

        expect(group.to_s).to eq "# comment"
      end
       
      it "adds no space if it's right after a breaking marker" do
        group = described_class.new(:group, indent: 0, line_length: 10)

        group << GroupIndent.new(2)
        group << "\n"
        group << BREAKING
        group << GroupTrailing.new("# comment")

        group.process

        expect(group.to_s).to eq "\n  # comment"
      end

      it "writes a newline if the next isn't a newline" do
        group = described_class.new(:group, indent: 0, line_length: 10)

        group << GroupTrailing.new("# comment")
        group << "hello"

        group.process

        expect(group.to_s).to eq "# comment\nhello"
      end

      it "breaks if the next isn't a newline" do
        group = described_class.new(:group, indent: 0, line_length: 10)

        group << GroupTrailing.new("# comment")
        group << BREAK_NOTE
        group << "hello"

        group.process

        expect(group.to_s).to eq "# comment\n#{BREAK_NOTE_TEXT}hello"
      end

      it "doesn't write a newline if next is a newline" do
        group = described_class.new(:group, indent: 0, line_length: 10)

        group << GroupTrailing.new("# comment")
        group << HARDLINE
        group << "hello"

        group.process

        expect(group.to_s).to eq "# comment\nhello"
      end

      it "writes a newline if it's the last of a group" do
        group = described_class.new(:group, indent: 0, line_length: 80)
        inner = described_class.new(:inner, indent: 0, line_length: 80)

        group << "hi"

        inner << GroupTrailing.new("# comment")
        group << inner

        group << "hi"

        group.process

        expect(group.to_s).to eq "hi # comment\nhi"
      end
    end

    describe "indent" do
      it "indents correctly" do
        group = described_class.new(:group, indent: 0, line_length: 10)

        group << GroupIndent.new(4)
        group << "hello!"
        group << "\n"
        group << "this should be 4 deep"
        group << GroupIndent.new(2)
        group << "\n"
        group << "2 deep"

        group.process

        expect(group.to_s).to include "    hello!"
        expect(group.to_s).to include "\n    this should be 4 deep"
        expect(group.to_s).to include "\n  2 deep"
      end

      it "works after a newline at the end of a group" do
        group = described_class.new(:group, indent: 0, line_length: 100)

        group << "hello!\n"
        group << GroupIndent.new(4)

        inner = described_class.new(:group, indent: 4, line_length: 100)
        inner << "hello!\n"
        group << inner

        group << "hello!"

        group.process

        expect(group.to_s).to eq "hello!\n    hello!\n    hello!"
      end

      it "indent around indent doesn't break things", focus: false do
        group = described_class.new(:group, indent: 0, line_length: 100)

        group << "when"
        group << " "
        group << "1"
        group << "\n"
        group << GroupIndent.new(2)
        group << GroupIndent.new(2)

        inner = described_class.new(:group, indent: 2, line_length: 100)
        inner << "hello!"
        group << inner

        group << GroupIndent.new(2)
        group << "\n"
        group << GroupIndent.new(0)
        group << "end"

        group.process

        expect(group.to_s).to eq "when 1\n  hello!\nend"
      end

      it "indented empty newline doesn't add any text", focus: false do
        group = described_class.new(:group, indent: 2, line_length: 100)

        group << "hello"
        group << "\n"
        group << "\n"
        group << "hello"

        group.process(column: 0)

        expect(group.to_s).to eq "  hello\n\n  hello"
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
