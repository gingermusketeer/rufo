module Rufo
  OP_MAP = {
    '-@': '-'
  }
  class RubyDocGenerator
    def initialize(ast)
      @ast = ast
    end

    def to_doc
      type, nodes = ast
      unless type == :program
        raise 'aw snap'
      end

      DocBuilder.join(
        DocBuilder::HARD_LINE,
        visit_all(nodes)
      )
    end

    private

    attr_reader :ast

    def visit_all(nodes)
      nodes.map { |node| visit(node) }
    end

    def visit(node)
      puts node.inspect
      case node.first
      when :assign
        _, target, value = node
        return DocBuilder.concat([
          visit(target),
          " = ",
          visit(value),
        ])
      when :opassign
        _, target, op, value = node
        return DocBuilder.concat([
          visit(target),
          " ",
          visit(op),
          " ",
          visit(value),
        ])
      when :var_field
        _, name, _ = node.last
        return name
      when :@int, :@gvar, :@op, :@ident
        _, value, _ = node
        return value
      when :binary
        _, left, op, right = node
        return DocBuilder.concat([
          visit(left),
          " #{op} ",
          visit(right),
        ])

      when :unary
        # [:unary, :-@, [:vcall, [:@ident, "x", [1, 2]]]]
        _, op, exp = node
        return DocBuilder.concat([
          OP_MAP.fetch(op),
          visit(exp),
        ])
      when :vcall
        # [:vcall, [:@ident, "foo", [1, 5]]]
        _, name = node.last
        return name
      when :alias, :var_alias
        # [:alias, [:symbol_literal, [:@ident, "foo", [2, 7]]], [:symbol_literal, [:@ident, "bar", [2, 12]]]]
        _, from, to = node
        return DocBuilder.concat([
          'alias ',
          visit(from),
          " ",
          visit(to),
        ])
      when :symbol_literal
        _, name = node.last
        puts 'here', node.inspect, name.inspect
        if name.is_a?(Array)
          name = ":#{name[1]}"
        end
        return name
      when :aref_field
        # [:aref_field, name, args]
        _, name, args = node
        return DocBuilder.concat([
          visit(name),
          "[",
          visit(args),
          "]"
        ])
      when :args_add_block
        # [:args_add_block, [[:vcall, [:@ident, "bar", [3, 5]]]], false]
        _, args = node
        return DocBuilder.join(",", visit_all(args))
      when :begin
        _, body = node
        return visit(body)
      when :bodystmt
        # [:bodystmt, body, rescue_body, else_body, ensure_body]
        _, body, rescue_body, else_body, ensure_body = node
        return DocBuilder.concat([
          "begin",
          DocBuilder.indent(
            DocBuilder.concat([
              DocBuilder::HARD_LINE,
              DocBuilder.join(DocBuilder::HARD_LINE, visit_all(body))
            ])
          ),
          DocBuilder::HARD_LINE,
          DocBuilder::LINE_SUFFIX_BOUNDARY,
          "end"
        ])
      when :case
        # [:case, cond, case_when]
        _, cond, case_when = node
        return DocBuilder.concat([
          "case",
          cond.nil? ? "" : " ",
          cond.nil? ? "" : visit(cond),
          DocBuilder::HARD_LINE,
          visit(case_when),
          DocBuilder::HARD_LINE,
          "end"
        ])
      when :when
        # [:when, conds, body, next_exp]
        _, conds, body, next_exp = node
        return DocBuilder.concat([
          DocBuilder::HARD_LINE,
          "when ",
          DocBuilder.join(",", visit_all(conds)),
          DocBuilder::HARD_LINE,
          DocBuilder.join(DocBuilder::HARD_LINE, visit_all(body)),
          next_exp.nil? ? "" : visit(next_exp)
        ])
      when :else
        # [:else, body]
        _, body = node
        return DocBuilder.concat([
          DocBuilder::HARD_LINE,
          "else",
          DocBuilder::HARD_LINE,
          DocBuilder.join(DocBuilder::HARD_LINE, visit_all(body))
        ])
      when :call
        # [:call, obj, :".", name]
        _, obj, op, name = node
        return DocBuilder.concat([
          visit(obj),
          op.to_s,
          visit(name)
        ])
      when :method_add_arg
        # foo(arg1, ..., argN)
        #
        # [:method_add_arg,
        #   [:fcall, [:@ident, "foo", [1, 0]]],
        #   [:arg_paren, [:args_add_block, [[:@int, "1", [1, 6]]], false]]]
        _, target, args = node
        return DocBuilder.concat([
          visit(target),
          visit(args)
        ])
      end
      pp node
      raise "unhandled #{node.inspect}"
    end
  end
end
