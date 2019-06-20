defmodule Basket.MixProject do
  use Mix.Project

  def project do
    [
      app: :basket,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:qErlang, git: "https://github.com/exxeleron/qErlang", tag: "1.0.0"},
      {:SnP500s, git: "https://github.com/datasets/s-and-p-500-companies" },
      {:nimble_csv, "~>0.6"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
