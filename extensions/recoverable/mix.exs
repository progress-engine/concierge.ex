defmodule Recoverable.Mixfile do
  use Mix.Project

 def project do
    [app: :recoverable,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

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
    [{:concierge, path: "../../"},
     {:phoenix_html, "~> 2.5", only: :test},
     {:phoenix_ecto, "~> 2.0", only: :test},
     {:postgrex, ">= 0.0.0", only: :test},
     {:mock, "~> 0.1.1", only: :test}]
  end
end
