defmodule Concierge.Extension do

	@doc """
	Invoke function on Concierge extensions
	"""
	def invoke(function, args \\ []) do
		Concierge.extensions 
      |> Enum.map(&apply_function(&1, function, args)) 
      |> Enum.reduce({:ok}, &reduce_result/2)
	end

	defp apply_function(extension, function, params) do
		try do
      apply(extension, function, params)
    rescue 
      UndefinedFunctionError -> nil  # Do nothing if function did not defined in extenstion module
    end
	end

	defp reduce_result(result, {:ok}) do
		case result do
      {:error, data} -> {:error, data}
      _ -> {:ok}
    end   
	end
	defp reduce_result(_, {:error, data}), do: {:error, data}
end