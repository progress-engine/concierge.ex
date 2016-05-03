defmodule Mix.Tasks.Recoverable.Install do
  use Mix.Task

  @shortdoc "Install recoverable module for Concierge"

  @moduledoc """
  Generates scaffold for Recoverable

    mix recoverable.install User users
  """

  def run(args) do
    {opts, parsed, _} = OptionParser.parse(args)
    [singular, plural | attrs] = validate_args!(parsed)

    binding = Mix.Phoenix.inflect(singular)
    binding = binding ++ [plural: plural]
    path = binding[:path]

    Mix.Phoenix.check_module_name_availability!(binding[:module])

    Mix.Phoenix.copy_from paths, "priv/templates/recoverable.install", "", binding, [
      {:eex, "migration.exs", "priv/repo/migrations/#{timestamp()}_add_recoverable_to_#{String.replace(path, "/", "_")}.exs"}
    ]

    Mix.Shell.IO.info """
    Three more steps to go:

    1. Add to models/#{singular}.ex:

      schema do
        ....
        
        field :reset_password_token, :string
        field :reset_password_token_sent_at, Ecto.DateTime
      end  

    2. Add recoverable extension
    
      config :concierge, Concierge,
        extensions: [Concierge.Recoverable] 
    """
  end

  @doc false
  defp validate_args!([_, plural] = args) do
    cond do
      plural != Phoenix.Naming.underscore(plural) ->
        Mix.raise "Expected the second argument, #{inspect plural}, to be all lowercase using snake_case convention"
      true ->
        args
    end
  end

  @doc false
  defp validate_args!(_) do
    raise_with_help
  end

  @doc false
  defp raise_with_help do
    Mix.raise """
    mix recoverable.install expects both singular and plural names
    of the generated resource followed by any number of attributes:
        mix recoverable.install User users
    """
  end

  @doc false
  defp paths do
    [".", :phoenix, :recoverable]
  end

  @doc false
  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  @doc false
  defp pad(i) when i < 10, do: << ?0, ?0 + i >>
  defp pad(i), do: to_string(i)
end
