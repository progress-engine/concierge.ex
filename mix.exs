defmodule Concierge.Mixfile do
  use Mix.Project

  def project do
    [app: :concierge,
     version: "0.0.1",
     description: description,
     package: package,
     elixir: "~> 1.1",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     test_pattern: "{controllers,unit}/**/*_test.exs" # workaround to exclude dummy app from tests
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: app_list(Mix.env)]
  end

  def app_list(:test), do: app_list ++ [:ecto, :postgrex, :phoenix_ecto]
  def app_list(_), do: app_list
  def app_list, do: [:logger, :phoenix, :guardian, :comeonin]

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp description do
    """
    Swiss army knife authentication framework for Elixir projects.
    """    
  end

  defp package do
     maintainers: ["Ivan Kryak", "Alexey Poimtsev"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/progress-engine/concierge.ex"}]
  end


  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:phoenix, "~> 1.1.4"},
     {:phoenix_html, "~> 2.5", only: :test},
     {:phoenix_ecto, "~> 2.0", only: :test},
     {:postgrex, ">= 0.0.0", only: :test},
     {:ecto, "~> 1.1.5"},
     {:guardian, "~> 0.10.1"},
     {:comeonin, "~> 2.1"}]
  end
end
