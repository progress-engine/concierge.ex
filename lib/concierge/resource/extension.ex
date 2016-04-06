defmodule Concierge.Extension do
  @moduledoc """
  """
  defmacro __using__(_opts) do
    quote do 
      import Concierge.Extension

      @before_create_functions []
      @after_create_functions []

      @before_compile Concierge.Extension
    end  
  end

  defmacro before_create(fun) do
    function_name = String.to_atom("before_create_" <> function_postfix)
    quote do 
      @before_create_functions [unquote(function_name) | @before_create_functions]
      def unquote(function_name)(changeset), do: unquote(fun).(changeset)
    end
  end

  defmacro before_sign_in(fun) do
    function_name = String.to_atom("before_sign_in_" <> function_postfix)
    quote do 
      @before_sign_in_functions [unquote(function_name) | @before_create_functions]
      def unquote(function_name)(changeset), do: unquote(fun).(changeset)
    end
  end

  defmacro after_create(fun) do
    function_name = String.to_atom("after_create_" <> function_postfix)
    quote do 
      @after_create_functions [unquote(function_name) | @after_create_functions]
      def unquote(function_name)(resource), do: unquote(fun).(resource)
    end
  end

  defp function_postfix, do: Module.split(__MODULE__) |> Enum.join("_")

  defmacro __before_compile__(env) do
    quote do
      def run_before_create_callbacks!(changeset) do      
        :ok = run_functions(@before_create_functions, changeset)
      end

      def run_after_create_callbacks!(resource) do      
        :ok = run_functions(@after_create_functions, resource)
      end

      def run_before_sign_in_callbacks!(resource) do
        :ok = run_functions(@before_sign_in_functions, resource)
      end

      defp run_functions([func_name | functions], parameter) do
        apply(__MODULE__, func_name, [parameter])

        run_functions(functions, parameter)
      end
      defp run_functions([], _), do: :ok
    end
  end
end