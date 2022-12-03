defmodule ReqAOC do
  @external_resource "README.md"
  @moduledoc @external_resource
             |> File.read!()
             |> String.split("<!-- MDOC -->")
             |> Enum.fetch!(1)

  @doc """
  Fetches Advent of Code input.

  ## Examples

      ReqAOC.fetch!({2022, 01, "my-session-id-from-dev-tools"})

      ReqAOC.fetch!({2022, 01, "my-session-id"}, max_retries: 0)
  """
  @spec fetch!(
          {year :: integer(), day :: integer(), session :: String.t()},
          options :: Keyword.t()
        ) ::
          String.t()
  def fetch!({year, day, session} = aoc, options \\ [])
      when is_integer(year) and is_integer(day) and is_binary(session) do
    Req.new()
    |> ReqAOC.attach()
    |> Req.get!([aoc: aoc] ++ options)
    |> Map.fetch!(:body)
  end

  @doc """
  Attaches to the given request.

  ## Request options

    * `:aoc` - A tuple `{year, day, session}`.

  """
  def attach(%Req.Request{} = request, options \\ []) do
    request
    |> Req.Request.register_options([:aoc])
    |> Req.Request.merge_options(options)
    |> Req.Request.append_request_steps(aoc: &build_aoc_url/1)
  end

  defp build_aoc_url(req) do
    if req.options[:aoc] do
      case req.options.aoc do
        {year, day, session} when is_integer(year) and is_integer(day) and is_binary(session) ->
          req
          |> Req.update(url: "https://adventofcode.com/#{year}/day/#{day}/input")
          |> Req.Request.put_header("cookie", ~s<session=#{session}>)

        other ->
          raise ArgumentError, "expected a tuple {Year, Day, Session}, got: #{inspect(other)}"
      end
    else
      req
    end
  end
end
