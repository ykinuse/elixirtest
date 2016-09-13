defmodule Tracer do
  def dump_args(args) do
    args
    |> Enum.map(&inspect/1)
    |> Enum.join(", ")
  end

  def dump_defn(name, nil) do
    "#{name}()"
  end

  def dump_defn(name, args) do
    "#{name}(#{Tracer.dump_args(args)})"
  end

  defmacro def(definition={name, _, args}, do: content) do
    quote do
      Kernel.def(unquote(definition)) do
        IO.puts("==> call #{Tracer.dump_defn(unquote(name), unquote(args))}")
        result = unquote(content)
        IO.puts("<== return #{result}")
        result
      end
    end
  end

  defmacro __using__(_opt) do
    quote do
      import(Kernel, except: [def: 2])
      import(Tracer, only: [def: 2])
    end
  end
end
