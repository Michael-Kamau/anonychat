defmodule AnonychatWeb.SocketOrigin do
  @moduledoc false

  def allowed?(%URI{} = uri) do
    allowed_origins()
    |> Enum.any?(fn allowed ->
      matches_origin?(uri, URI.parse(allowed))
    end)
  end

  defp allowed_origins do
    case System.get_env("CHECK_ORIGIN") do
      nil ->
        [
          "#{System.get_env("PHX_SCHEME") || "https"}://#{System.get_env("PHX_HOST") || "example.com"}:#{url_port()}"
        ]

      "false" ->
        []

      origins ->
        origins
        |> String.split(",", trim: true)
        |> Enum.map(&String.trim/1)
    end
  end

  defp url_port do
    case System.get_env("URL_PORT") do
      nil ->
        if (System.get_env("PHX_SCHEME") || "https") == "https", do: "443", else: "80"

      value ->
        value
    end
  end

  defp matches_origin?(%URI{} = request_uri, %URI{} = allowed_uri) do
    request_uri.scheme == allowed_uri.scheme and
      request_uri.host == allowed_uri.host and
      request_port(request_uri) == request_port(allowed_uri)
  end

  defp request_port(%URI{port: nil, scheme: "https"}), do: 443
  defp request_port(%URI{port: nil, scheme: "http"}), do: 80
  defp request_port(%URI{port: port}), do: port
end
