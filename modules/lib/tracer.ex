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

  defmacro def(definition = {:when, _, [function = {name, _, args} | _clause]}, do: content) do
    impl_def(definition, name, args, content)
  end

  defmacro def(definition={name, _, args}, do: content) do
    impl_def(definition, name, args, content)
  end

  defp impl_def(definition, name, args, content) do
    quote do
      Kernel.def(unquote(definition)) do
        IO.puts("==> call #{Tracer.dump_defn(unquote(name), unquote(args))}")
        result = unquote(content)
        IO.puts("<== return #{result}")
        result
      end
    end
  end

  defmacro def_sub_module(name) do
    quote do
      Kernel.defmodule(unquote(name)) do
        Tracer.def get_name(), do: "#{inspect(__MODULE__)}"
      end
    end
  end

  defmacro def_new_module(name) do
    quote bind_quoted: [name: name] do
      Kernel.defmodule(name) do
        def get_name(), do: "#{inspect(__MODULE__)}"
      end
    end
  end

  defmacro __using__(_opt) do
    quote do
      import(Kernel, except: [def: 2])
      import(unquote(__MODULE__), only: [def: 2, def_sub_module: 1])
    end
  end
end
