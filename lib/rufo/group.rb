module Rufo
  GroupIndent = Struct.new(:indent)
  GroupIfBreak = Struct.new(:break_value, :no_break_value)
  GroupTrailing = Struct.new(:value)

  LINE = GroupIfBreak.new("\n", " ")
  SOFTLINE = GroupIfBreak.new("\n", "")
  HARDLINE = "\n"
  BREAKING = :breaking

  class Group
    def self.string_value(token, breaking: false, column: 0)
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

    def process(column: indent, allow_break: true)
      output, needs_break = build_buffer_string(column: column, breaking: false)

      if needs_break && allow_break
        output, needs_break = build_buffer_string(column: column, breaking: true)
      end

      @buffer_string = output
      [output, needs_break]
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
    
    def build_buffer_string(column:, breaking:)
      debug "build_buffer_string: #{name}"
      indent = @indent
      needs_break = breaking
      last_was_newline = false
      output = "".dup
      tokens = buffer.dup
      first_token = true

      append = lambda do |value|
        value.each_char do |char|
          output << char
          column += char.length

          if column > @line_length && !needs_break
            needs_break = true
            # short circuit the loop
            tokens = []
          end

          if char == "\n"
            column = 0
          end
        end

        debug "#{name}.append(#{value.ai})\tcolumn: #{column.ai}\tneeds break: #{needs_break.ai}"
      end

      while token = tokens.shift
        if token.is_a?(GroupIndent)
          indent = token.indent
          column = indent if last_was_newline
          next
        elsif token == BREAKING
          needs_break = true
          next
        elsif token.is_a?(Group)
          group_output, group_needs_break = token.process(column: column, allow_break: breaking)

          tokens.unshift(BREAKING) if group_needs_break
          tokens.unshift(group_output)
          next
        end

        string_value = self.class.string_value(token, breaking: breaking, column: column)
        current_is_newline = string_value == "\n"

        if last_was_newline && !current_is_newline
          append.call(" " * indent)
        end

        case token
        when String
          append.call string_value
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

    def debug(message)
      puts(message) if DEBUG
    end
  end
end
