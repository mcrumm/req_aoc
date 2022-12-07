defmodule ReqAOC do
  @external_resource "README.md"
  @moduledoc @external_resource
             |> File.read!()
             |> String.split("<!-- MDOC -->")
             |> Enum.fetch!(1)

  @deprecated "Use fetch!/2 instead"
  @spec fetch!({year :: integer(), day :: integer(), session :: String.t()}) :: String.t()
  def fetch!({year, day, session}) do
    fetch!(session, {year, day}, [])
  end

  @doc """
  Refer to `fetch!/3`.
  """
  def fetch!({year, day, session}, options) do
    IO.warn(
      "fetch!/2 with a {Year, Day, Session} tuple is deprecated." <> " Use fetch!/3 instead."
    )

    fetch!(session, {year, day}, options)
  end

  def fetch!(session, {year, day}) do
    fetch!(session, {year, day}, [])
  end

  @doc """
  Fetches Advent of Code input.

  ## Examples

      ReqAOC.fetch!("my-session-id", {2022, 01})
      #=> "..."

      ReqAOC.fetch!("my-session-id", {2022, 01}, max_retries: 0)
      #=> "..."
  """
  @spec fetch!(
          session :: String.t(),
          {year :: integer(), day :: integer()},
          options :: Keyword.t()
        ) :: String.t()
  def fetch!(session, {year, day}, options)
      when is_binary(session) and is_integer(year) and is_integer(day) and is_list(options) do
    Req.new()
    |> ReqAOC.attach()
    |> Req.get!([aoc: {year, day, session}] ++ options)
    |> Map.fetch!(:body)
  end

  @doc """
  Attaches to the given request.

  ## Request options

    * `:aoc` - A tuple `{year, day, session}`.

  ## Examples

      req = Req.new() |> ReqAOC.attach()
      req |> Req.get!(aoc: {2022, 01, "my-session-id"})
      #=> %Req.Response{body: "..."}

  """
  def attach(%Req.Request{} = request, options \\ []) do
    request
    |> Req.Request.register_options([:aoc])
    |> Req.Request.merge_options(options)
    |> Req.Request.append_request_steps(aoc: &__MODULE__.put_aoc/1)
  end

  @doc false
  def put_aoc(req) do
    if req.options[:aoc] do
      case req.options.aoc do
        {year, day, session} when is_integer(year) and is_integer(day) and is_binary(session) ->
          req
          |> Req.update(url: "https://adventofcode.com/#{year}/day/#{day}/input")
          |> Req.Request.put_header("cookie", ~s<session=#{session}>)

        other ->
          raise ArgumentError,
                "invalid options given to ReqAOC" <>
                  ", expected a tuple {Year, Day, Session}, got: #{inspect(other)}"
      end
    else
      req
    end
  end
end
