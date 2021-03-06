defmodule EvercamMedia.ONVIFControllerErrorsTest do
  use EvercamMedia.ConnCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney, options: [clear_mock: true]
  import EvercamMedia.ConnCase ,only: [parse_onvif_error_type: 1]

  @auth System.get_env["ONVIF_AUTH"]

  @moduletag :onvif
  @access_params "url=http://recorded_response&auth=#{@auth}"

  @tag :skip
  @tag :capture_log
  test "GET /v1/onvif/v20/DeviceIO/GetUnknownAction" do
    use_cassette "error_unknown_action" do
      conn = get build_conn(), "/v1/onvif/v20/DeviceIO/GetUnknownAction?#{@access_params}"
      error_type = json_response(conn, 500) |> parse_onvif_error_type
      assert error_type == "ter:ActionNotSupported"
    end
  end

  @tag :skip
  @tag :capture_log
  test "bad credentials" do
    use_cassette "error_bad_credentials" do
      conn = get build_conn(), "/v1/onvif/v20/device_service/GetNetworkInterfaces?url=http://recorded_response&auth=admin:foo"
      error_type = json_response(conn, 400) |> parse_onvif_error_type
      assert error_type == "ter:NotAuthorized"
    end
  end

  @tag :skip
  @tag :capture_log
  test "Service not available" do
    use_cassette "error_service_not_available" do
      conn = get build_conn(), "/v1/onvif/v20/Display/GetServiceCapabilities?#{@access_params}"
      error_type = json_response(conn, 500) |> parse_onvif_error_type
      assert error_type == "ter:ActionNotSupported"
    end
  end

  @tag :skip
  @tag :capture_log
  test "bad parameter" do
    use_cassette "error_bad_parameter" do
      conn = get build_conn(), "/v1/onvif/v20/Media/GetSnapshotUri?#{@access_params}&ProfileToken=Foo"
      error_type = json_response(conn, 500) |> parse_onvif_error_type
      assert error_type == "ter:InvalidArgVal"
    end
  end

  @tag :skip
  @tag :capture_log
  test "request timeout" do
    use_cassette "error_request_timeout" do
      conn = get build_conn(), "/v1/onvif/v20/device_service/GetNetworkInterfaces?url=http://192.10.20.30:8100&auth=foo:bar"
      [timeout_message] = json_response(conn, 500)
      assert timeout_message == "req_timedout"
    end
  end

  @tag :skip
  @tag :capture_log
  test "bad url" do
    use_cassette "error_bad_url" do
      conn = get build_conn(), "/v1/onvif/v20/device_service/GetNetworkInterfaces?url=abcde&auth=foo:bar"
      [_ , ["error", error]] = json_response(conn, 500)
      assert error == "nxdomain"
    end
  end

end
