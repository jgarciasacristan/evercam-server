defmodule EvercamMedia.Mixfile do
  use Mix.Project

  def project do
    [app: :evercam_media,
     version: "1.0.1",
     elixir: "~> 1.4.0",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     compilers: [:phoenix] ++ Mix.compilers,
     aliases: aliases(),
     deps: deps()]
  end

  defp aliases do
    [clean: ["clean"]]
  end

  def application do
    [mod: {EvercamMedia, []},
     applications: app_list(Mix.env)]
  end

  defp app_list(:dev), do: [:dotenv, :credo | app_list()]
  defp app_list(:test), do: [:dotenv | app_list()]
  defp app_list(_), do: app_list()
  defp app_list, do: [
    :calendar,
    :cf,
    :comeonin,
    :con_cache,
    :connection,
    :cors_plug,
    :cowboy,
    :ecto,
    :geo,
    :httpoison,
    :inets,
    :jsx,
    :mailgun,
    :meck,
    :phoenix,
    :phoenix_ecto,
    :phoenix_html,
    :phoenix_pubsub,
    :porcelain,
    :postgrex,
    :quantum,
    :runtime_tools,
    :timex,
    :tzdata,
    :uuid,
    :xmerl,
    :html_sanitize_ex,
  ]

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [
      {:calendar, "~> 0.17.1"},
      {:comeonin, "~> 3.0"},
      {:con_cache, "~> 0.12.0"},
      {:cors_plug, "~> 1.1.4"},
      {:cowboy, "~> 1.0.0"},
      {:credo, "~> 0.6.1", only: :dev},
      {:dotenv, "~> 2.1.0", only: [:dev, :test]},
      {:ecto, "~> 2.1.3"},
      {:exrm, "~> 1.0.8"},
      {:geo, "~> 1.3.1"},
      {:httpoison, "~> 0.11.0"},
      {:jsx, "~> 2.8.2"},
      {:mailgun, github: "evercam/mailgun"},
      {:phoenix, "~> 1.2.0"},
      {:phoenix_ecto, "~> 3.2.1"},
      {:phoenix_html, "~> 2.9.3"},
      {:porcelain, "~> 2.0.3"},
      {:postgrex, "~> 0.13.0"},
      {:quantum, "~> 1.8.1"},
      {:uuid, "~> 1.1.6"},
      {:relx, "~> 3.22.2"},
      {:erlware_commons, "~> 0.22.0"},
      {:cf, "~> 0.2.2"},
      {:exvcr, "~> 0.8.7", only: :test},
      {:meck,  "~> 0.8.4"},
      {:timex,  "~> 3.1.9"},
      {:html_sanitize_ex, "~> 1.1.1"},
    ]
  end
end
