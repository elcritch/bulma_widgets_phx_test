defmodule BulmaWidgetsPhxTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :bulma_widgets_phx_test,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {BulmaWidgetsPhxTest.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      if Application.get_env(:bulma_widgets_phx_test, :environment) == :dev_local do
        {:bulma_widgets, "~> 0.1.0", path: "../bulma_widgets"}
      else
        {:bulma_widgets, "~> 0.1.0", github: "elcritch/bulma_widgets"}
      end,
      {:phoenix, "~> 1.4.15"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:phoenix_live_view, "~> 0.10"}
    ]
  end
end
