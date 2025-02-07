defmodule Wildfires.HTTPClient do
  @moduledoc false

  @service_id "RHVPKKiFTONKtxq3"
  @layer_id "0"
  @base_url "https://services9.arcgis.com/#{@service_id}/arcgis/rest/services"
  @service_name "USA_Wildfires_v1"
  @query_path "FeatureServer/#{@layer_id}/query"
  @query_params %{
    # "SELECT ALL"
    "where" => "1=1",
    "f" => "geojson"
  }

  @full_query_url "#{@base_url}/#{@service_name}/#{@query_path}#{URI.encode_query(@query_params)}"

  def get_wildfires() do
    [
      base_url: @base_url
    ]
    |> Keyword.merge(Application.get_env(:wildfires, :api, []))
    |> Req.request()
  end
end
