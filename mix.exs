defmodule ReqAOC.MixProject do
  use Mix.Project

  @source_url "https://github.com/mcrumm/req_aoc"

  @version "0.1.0"

  def project do
    [
      app: :req_aoc,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      preferred_cli_env: [
        docs: :docs
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:req, "~> 0.3.2"},
      {:plug, "> 0.0.0", only: :test},
      {:ex_doc, "> 0.0.0", only: :docs}
    ]
  end

  defp docs do
    [
      source_url: @source_url,
      source_ref: "v#{@version}",
      language: "en",
      formatters: ["html"],
      main: "usage",
      extras: ["guides/usage.livemd"]
    ]
  end
end
