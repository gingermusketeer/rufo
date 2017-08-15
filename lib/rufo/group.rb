module Rufo
  GroupIndent = Struct.new(:indent)
  GroupIfBreak = Struct.new(:break_value, :no_break_value)
  GroupTrailing = Struct.new(:value)

  LINE = :line
  SOFTLINE = :softline
  HARDLINE = :hardline
  BREAKING = :breaking

  class Group
    def self.string_value(token, breaking: false)
      case token
      when LINE
        breaking ? "\n" : " "
      when SOFTLINE
        breaking ? "\n" : ""
      when HARDLINE
        "\n"
      when GroupIfBreak
        breaking ? token.break_value : token.no_break_value
      when GroupTrailing
        token.value
      when String
        token
      when Group
        token.buffer_string
      when BREAKING
        ""
      else
        fail "Unknown token #{token.ai}"
      end
    end

    def initialize(indent:, line_length:)
      @indent = indent
      @buffer = []
      @line_length = line_length
      @breaking = false
    end

    attr_accessor :buffer
    attr_reader :breaking

    def buffer_string
      output, needs_break = build_buffer_string(breaking: false)
      # @non_breaking_length = output.length + @indent

      if needs_break
        @breaking = true
        build_buffer_string(breaking: true).first
      else
        output
      end
    end

    private
    
    def build_buffer_string(breaking:)
      indent = @indent
      column = @indent
      needs_break = false
      last_was_newline = false
      output = "".dup
      tokens = buffer.dup
      first_token = true

      append = lambda do |value|
        output << value
        column += value.chomp.length

        if column > @line_length
          needs_break = true
        end

        if value.end_with?("\n")
          column = indent
        end
      end

      while token = tokens.shift
        if token.is_a?(GroupIndent)
          indent = token.indent
          column = indent
          next
        elsif token == BREAKING
          needs_break = true
          next
        end

        string_value = self.class.string_value(token, breaking: breaking)
        current_is_newline = string_value == "\n"

        if last_was_newline && !current_is_newline
          append.call(" " * indent)
        end

        case token
        when String, LINE, SOFTLINE, HARDLINE
          append.call string_value
        when Group
          append.call string_value
          needs_break = true if token.breaking
        when GroupTrailing
          append.call " " unless last_was_newline || first_token
          append.call string_value
        when GroupIfBreak
          tokens.unshift(string_value)
        else
          fail "Unknown token #{token.ai}"
        end

        last_was_newline = current_is_newline
        first_token = false
      end

      [output, needs_break]
    end
  end
end
