defmodule Concierge.Utils do
  
  @doc """
  Generates a string randomly to be used as token. By default, length is 32 characters.
  """
  def generate_token(length \\ 32) do
    :crypto.strong_rand_bytes(length) 
      |> Base.url_encode64 
      |> binary_part(0, length)
  end

  @doc """
  Run function for a set of Concierge extensions
  """
  def invoke_on_extensions(function, params) do
    Concierge.Extension.invoke(function, params)
  end

  @doc """
  Returns changeset from given parameters
  """
  def changeset(params \\ :empty) do
    Concierge.resource.changeset(Concierge.resource.__struct__, params) 
  end
end