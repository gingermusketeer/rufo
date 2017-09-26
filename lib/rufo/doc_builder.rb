module Rufo
  class DocBuilder

    class << self
      def concat(parts)
        assert_docs(parts)
        {
          type: :concat, parts: parts
        }
      end

      def indent(contents)
        assert_doc(contents)
        {
          type: :indent, contents: contents
        }
      end

      def align(n, contents)
        assert_doc(contents)
        { type: :align, contents: contents, n: n }
      end

      def group(contents, opts = {})
      assert_doc(contents)
      {
        type: :group,
        contents: contents,
        break: !!opts[:should_break],
        expanded_states: opts[:expanded_states]
      }
      end

      def conditional_group(states, opts)
        group(states.first, opts.merge(expanded_states: states))
      end

      def fill(parts)
        assert_docs(parts)

        { type: :fill, parts: parts }
      end

      def if_break(break_contents, flat_contents)
        assert_doc(break_contents) if break_contents.present?
        assert_doc(flat_contents) if flat_contents.present?

        { type: :if_break, break_contents: break_contents, flat_contents: flat_contents }
      end

      def line_suffix(contents)
        assert_doc(contents)
        { type: :line_suffix, contents: :contents }
      end

      def join(sep, arr)
        concat(arr.zip([sep]).flatten.compact)
      end

      def add_alignment_to_doc(doc, size, tab_width)
        return doc unless size > 0
        (size/tab_width).times { doc = indent(doc) }
        doc = align(size % tab_width, doc)
        align(-Float::INFINITY, doc)
      end

      private

      def assert_docs(parts)
        parts.each(&method(:assert_doc))
      end

      def assert_doc(val)
        unless val.is_a?(String) || (val.is_a?(Hash) && val[:type].is_a?(String))
          raise new InvalidDocError("Value #{val.inspect} is not a valid document")
        end
      end
    end

    LINE_SUFFIX_BOUNDARY = { type: :line_suffix_boundary }
    BREAK_PARENT = { type: :break_parent }
    LINE = { type: :line }
    SOFT_LINE = { type: :line, soft: true }
    HARD_LINE = concat([{type: :line, hard: true}, BREAK_PARENT])
    LITERAL_LINE = concat([
      { type: :line, hard: true, literal: true },
      BREAK_PARENT
    ])
    CURSOR = { type: :cursor, placeholder: :cursor }
  end
end
