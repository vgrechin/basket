defmodule Basket.MixProject do
  use Mix.Project

  def project do
    [
      app: :basket,
      version: "1.0.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        basket: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent]
        ],
        bootcamp: [
          include_executables_for: [:windows],
          applications: [runtime_tools: :permanent]
        ],
      ],
      default_release: :basket,
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: { Basket, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:qErlang, git: "https://github.com/exxeleron/qErlang", tag: "1.0.0"},
      {:SnP500s, git: "https://github.com/datasets/s-and-p-500-companies", app: false, compile: false },
      {:nimble_csv, "~>0.6"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
