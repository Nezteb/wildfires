defmodule Wildfires.HTTPClient do
  @moduledoc """
  A Req-based HTTP client for interacting with the ArcGIS API.
  """

  require Logger

  @service_id "RHVPKKiFTONKtxq3"
  @layer_id "0"
  @base_url "https://services9.arcgis.com/:service_id/arcgis/rest/services"
  @service_name "USA_Wildfires_v1"
  @query_path "FeatureServer/:layer_id/query"
  @query_params [
    # "SELECT ALL"
    where: "1=1",
    f: "geojson"
  ]

  @full_query_url "#{@base_url}/#{@service_name}/#{@query_path}"

  def get_wildfires() do
    [
      base_url: @full_query_url,
      params: @query_params,
      path_params: [
        service_id: @service_id,
        layer_id: @layer_id
      ],
      retry: false
    ]
    |> Keyword.merge(get_config())
    |> Req.request()
    |> handle_response()
  end

  defp get_config(), do: Application.get_env(:wildfires, :api, [])

  defp handle_response({:ok, %{status: status} = response})
       when status >= 200 and status <= 299 do
    {:ok, response.body}
  end

  defp handle_response({:ok, %{status: status}}) do
    Logger.error("Received error status from API", status: status)
    {:ok, []}
  end

  defp handle_response({:error, response}) do
    {:error, response}
  end
end
