defmodule My do
  defmacro if(condition, clauses) do
    do_clause = Keyword.get(clauses, :do, nil)
    else_clause = Keyword.get(clauses, :else, nil)

    quote do
      case unquote(condition) do
        val when val in [false, nil]
          -> unquote(else_clause)
        _others
          -> unquote(do_clause)
      end
    end
  end

  defmacro unless(condition, expression) do
    _unless(condition, Keyword.get(expression, :do, expression))
  end

  defp _unless(condition, expression) do
    quote do
      if !unquote(condition) do
        unquote(expression)
      end
    end
  end

  defmacro times_n(n) do
    func = :"times_#{n}"
    quote do
      def unquote(func)(x), do: x*unquote(n)
    end
  end

  defmacro q(n) do
    quote do
      unquote(n)
    end
  end
end
