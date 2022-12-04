defmodule ReqAOCTest do
  use ExUnit.Case, async: false

  def check(conn) do
    [cookie] = Plug.Conn.get_req_header(conn, "cookie")
    assert %{"session" => session} = Plug.Conn.Utils.params(cookie)
    %{scheme: scheme, host: host, request_path: path} = conn
    Plug.Conn.send_resp(conn, 200, "#{scheme}://#{host}#{path}|#{session}")
  end

  test "fetch!/2 sends the session cookie and returns the response body" do
    assert ReqAOC.fetch!("session", {2022, 01}, plug: &check/1) ==
             "https://adventofcode.com/2022/day/1/input|session"
  end

  test "fetch!/1 deprecated format" do
    assert ReqAOC.fetch!({2022, 01, "session"}, plug: &check/1) ==
             "https://adventofcode.com/2022/day/1/input|session"
  end

  test "request fails with invalid options" do
    assert_raise ArgumentError, ~r/invalid options given to ReqAOC/, fn ->
      Req.new()
      |> ReqAOC.attach(aoc: :ok)
      |> Req.get(plug: &check/1)
    end

    assert_raise ArgumentError, ~r/invalid options given to ReqAOC/, fn ->
      Req.new()
      |> ReqAOC.attach(aoc: {:ok, 2022, 01})
      |> Req.get(plug: &check/1)
    end
  end

  test "skips requests without aoc option" do
    assert Req.new()
           |> ReqAOC.attach()
           |> Req.get!(plug: fn conn -> Plug.Conn.send_resp(conn, 200, "ok") end)
           |> Map.fetch!(:body) == "ok"
  end
end
