defmodule ReqAOCTest do
  use ExUnit.Case

  test "fetch!/1 sends the session cookie and returns the response body" do
    assert ReqAOC.fetch!({2022, 01, "session"},
             plug: fn conn ->
               [cookie] = Plug.Conn.get_req_header(conn, "cookie")
               assert %{"session" => session} = Plug.Conn.Utils.params(cookie)
               %{scheme: scheme, host: host, request_path: path} = conn
               Plug.Conn.send_resp(conn, 200, "#{scheme}://#{host}#{path}|#{session}")
             end
           ) == "https://adventofcode.com/2022/day/1/input|session"
  end

  test "request fails with invalid options" do
    assert_raise ArgumentError, "expected a tuple {Year, Day, Session}, got: :ok", fn ->
      Req.new()
      |> ReqAOC.attach(aoc: :ok)
      |> Req.get(plug: fn conn -> Plug.Conn.send_resp(conn, 200, "ok") end)
    end
  end

  test "skips requests without aoc option" do
    assert Req.new()
           |> ReqAOC.attach()
           |> Req.get!(plug: fn conn -> Plug.Conn.send_resp(conn, 200, "ok") end)
           |> Map.fetch!(:body) == "ok"
  end
end
