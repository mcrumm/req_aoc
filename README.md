# ReqAOC

<!-- MDOC -->

Elixir Req plugin to download Advent of Code input.

## Usage

Use the `ReqAOC.fetch!/1` convenience function:

```elixir
ReqAOC.fetch!({2022, 01, "my-session-id-from-dev-tools"})
# ==> "..."
```

...or attach ReqAOC to an existing `Req.Request`:

```elixir
Req.new()
|> ReqAOC.attach()
|> Req.get!(aoc: {2022, 01, "my-session-id-from-dev-tools"})
# ==> %Req.Response{body: "..."}
```

<!-- MDOC -->

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `req_aoc` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:req_aoc, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/req_aoc>.
