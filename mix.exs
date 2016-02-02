defmodule AlexaPlug.Mixfile do
  use Mix.Project

  def project do
    [app: :alexa_plug,
     version: "0.1.0",
     elixir: "~> 1.2",
     description: description,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package,
     test_coverage: [tool: ExCoveralls]]
  end

  def application do
    [applications: [:logger]]
  end

  defp description do
    """
    A simple set of plugs and utilities for interfacing with the Amazon
    Echo and the Alexa Skills Kit.
    """
  end

  defp deps do
    [{:plug, "~> 1.1.0"},
     {:excoveralls, "~> 0.4", only: :test},
     {:ex_doc, "~> 0.11.4", only: :doc},
     {:earmark, "~> 0.2.1", only: :doc}]
  end

  defp package do
    [maintainers: ["Jordan Davis"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/jordantdavis/alexa_plug"}]
  end
end
