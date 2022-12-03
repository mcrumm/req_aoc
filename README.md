# ReqAOC

<!-- MDOC -->

Elixir Req plugin to download [Advent of Code](https://adventofcode.com) input.

## Usage

The easiest way to use Req is with `Mix.install/2` (requires Elixir v1.12+):

```elixir
Mix.install([
  {:req_aoc, github: "mcrumm/req_aoc", ref: "28e3813"}
])

ReqAOC.fetch!({2022, 01, "my-session-id-from-dev-tools"})
# ==> "..."
```

If you want to use ReqAOC in a Mix project, you can add the above dependency to your `mix.exs`.

You can also attach ReqAOC to an existing `Req.Request`:

```elixir
Req.new()
|> ReqAOC.attach()
|> Req.get!(aoc: {2022, 01, "my-session-id-from-dev-tools"})
# ==> %Req.Response{body: "..."}
```

<!-- MDOC -->
