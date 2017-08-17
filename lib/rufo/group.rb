module Rufo
  GroupIndent = Struct.new(:indent)
  GroupIfBreak = Struct.new(:break_value, :no_break_value)
  GroupTrailing = Struct.new(:value)

  LINE = GroupIfBreak.new("\n", " ")
  SOFTLINE = GroupIfBreak.new("\n", "")
  HARDLINE = "\n"
  BREAKING = :breaking

  class Group
    def self.string_value(token, breaking: false)
      case token
      when GroupIfBreak
        breaking ? token.break_value : token.no_break_value
      when GroupTrailing
        token.value
      when String
        token
      when BREAKING
        ""
      else
        fail "Unknown token #{token.ai}"
      end
    end

    def initialize(name, indent:, line_length:)
      @name = name || object_id
      @indent = indent
      @buffer = []
      @buffer_string = nil
      @line_length = line_length
    end

    attr_reader :name, :indent

    DEFAULT_BREAKING_BUFFER = Struct.new(:max_column).new(Float::INFINITY)

    def process(column: indent, allow_break: true, last_kind: :newline)
      breaking_buffer = DEFAULT_BREAKING_BUFFER

      non_breaking_buffer = process_buffer(column: column, breaking: false, last_kind: last_kind)

      force_break = non_breaking_buffer.force_break
      too_long = non_breaking_buffer.max_column > @line_length
      needs_break = force_break || (allow_break && too_long)

      if needs_break
        breaking_buffer = process_buffer(column: column, breaking: true, last_kind: last_kind)
      end

      buffer = if force_break
                 breaking_buffer
               elsif needs_break && (breaking_buffer.max_column < non_breaking_buffer.max_column)
                 breaking_buffer
               else
                 non_breaking_buffer
               end

      @buffer_string = buffer.to_s
      buffer
    end

    def <<(value)
      buffer << value
    end

    def concat(value)
      buffer.concat(value)
    end

    def to_s
      fail "you need to call process first" unless @buffer_string

      @buffer_string
    end

    private

    attr_accessor :buffer
    
    def process_buffer(column:, breaking:, last_kind:)
      debug "process_buffer: #{name} #{object_id} last_kind: #{last_kind.ai}"
      indent = @indent
      force_break = breaking
      max_column = column
      output = "".dup
      tokens = buffer.dup
      first_token = true

      append = lambda do |value|
        value.each_char do |char|
          output << char

          if char == "\n"
            last_kind = :newline
            column = 0
          else
            last_kind = :char
            column += char.length
          end

          if column > max_column
            max_column = column
          end
        end

        debug "#{name}.append(#{value.ai})\tcolumn: #{column.ai}"
      end

      while token = tokens.shift
        if token.is_a?(GroupIndent)
          indent = token.indent
          next
        elsif token == BREAKING
          force_break = true
          next
        elsif token.is_a?(Group)
          group_buffer = token.process(column: column, allow_break: breaking, last_kind: last_kind)

          force_break = true if group_buffer.force_break
          append.call group_buffer.to_s
          last_kind = group_buffer.last_kind
          next
        end

        string_value = self.class.string_value(token, breaking: breaking)
        is_empty_newline = string_value == "\n"

        if last_kind == :trailing && !is_empty_newline
          tokens.unshift(token)
          tokens.unshift(BREAKING)
          tokens.unshift(HARDLINE)
          next
        end

        printed_indent = false

        if last_kind == :newline && !is_empty_newline
          level = (indent - column).negative? ? 0 : (indent - column)

          append.call(" " * level)
          printed_indent = true
        end

        case token
        when String
          append.call string_value
        when GroupTrailing
          append.call " " unless printed_indent
          append.call string_value
          last_kind = :trailing
        when GroupIfBreak
          tokens.unshift(string_value)
        else
          fail "Unknown token #{token.ai}"
        end

        first_token = false
      end

      ProcessedBuffer.new(
        output,
        max_column: max_column,
        force_break: force_break,
        last_kind: last_kind,
      )
    end

    def debug(message)
      puts(message) if DEBUG
    end

    class ProcessedBuffer
      def initialize(to_s, max_column:, force_break:, last_kind:)
        @to_s = to_s
        @max_column = max_column
        @force_break = force_break
        @last_kind = last_kind
      end

      attr_reader :to_s, :max_column, :force_break, :last_kind
    end
  end
end
