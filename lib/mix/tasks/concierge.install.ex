defmodule Mix.Tasks.Concierge.Install do
	use Mix.Task

	@shortdoc "Generates basic scaffold for Concierge"

	@moduledoc """
	Generates scaffold for Concierge

		mix concierge.install User users
	"""

	def run(args) do
		{opts, parsed, _}	= OptionParser.parse(args)
		[singular, plural | attrs] = validate_args!(parsed)

		binding = Mix.Phoenix.inflect(singular)
		binding = binding ++ [plural: plural]
		path = binding[:path]

		Mix.Phoenix.check_module_name_availability!(binding[:module])

		Mix.Phoenix.copy_from paths, "priv/templates/concierge.install", "", binding, [
			{:eex, "model.ex", "web/models/#{path}.ex"},
			{:eex, "migration.exs", "priv/repo/migrations/#{timestamp()}_create_concierge_#{String.replace(path, "/", "_")}.exs"},
      {:eex, "guardian_serializer.ex", "lib/concierge/guardian_serializer.ex"},
      {:eex, "config.exs", "config/concierge.exs"}
		]
    # TODO add instructions
	end

	defp validate_args!([_, plural] = args) do
		cond do
      plural != Phoenix.Naming.underscore(plural) ->
        Mix.raise "Expected the second argument, #{inspect plural}, to be all lowercase using snake_case convention"
      true ->
        args
    end
	end

	defp validate_args!(_) do
		raise_with_help
	end

  defp raise_with_help do
    Mix.raise """
    mix concierge.install expects both singular and plural names
    of the generated resource followed by any number of attributes:
        mix concierge.install User users
    """
  end

  defp paths do
    [".", :phoenix, :concierge]
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: << ?0, ?0 + i >>
  defp pad(i), do: to_string(i)
end
