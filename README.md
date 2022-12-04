# ReqAOC

<!-- MDOC -->

Elixir Req plugin to download [Advent of Code][aoc] input.

## Usage

The easiest way to use Req is with `Mix.install/2` (requires Elixir v1.12+):

```elixir
Mix.install([
  {:req_aoc, github: "mcrumm/req_aoc"}
])

System.fetch_env!("AOC_SESSION") |> ReqAOC.fetch!({2022, 01})
# ==> "..."
```

If you want to use ReqAOC in a Mix project, you can add the above dependency to your `mix.exs`.

You can also attach ReqAOC to an existing `Req.Request`:

```elixir
req = Req.new() |> ReqAOC.attach()
req |> Req.get!(aoc: {2022, 01, "my-session-id-from-dev-tools"})
# ==> %Req.Response{body: "..."}
```

### Livebook

In [Livebook](https://livebook.dev) you can store your session token as an **app secret** so you
can reuse it across multiple sessions and multiple notebooks. For example, if you create a secret
named `AOC_SESSION`, then you can use the following code snippet to fetch your AoC input:

```elixir
System.fetch_env!("LB_AOC_SESSION") |> ReqAOC.fetch!({2022, 01})
```

## How to get your session cookie

Puzzle inputs differ by user. For this reason, you can't get your data with an unauthenticated request. Here's how to get your session cookie for ReqAOC to use:

* Log in on [Advent of Code][aoc] via any available provider.
* Open your browser's developer console (e.g. right click --> Inspect) and navigate to the Network tab.
* GET any input page, for example https://adventofcode.com/2022/day/1/input, and search in the **request headers**.
* It's a long hex string. You want the part that comes _after_ `Cookie: session=`. Save that to a system environment variable or a Livebook app secret called `AOC_SESSION`.

[![Finding your session token](https://cloud.githubusercontent.com/assets/6615374/20862970/0922a4fe-b980-11e6-8f30-5967ca494f5e.png)](https://github.com/wimglenn/advent-of-code-wim/issues/1)

[aoc]: https://adventofcode.com

<!-- MDOC -->
