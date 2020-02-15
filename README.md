# Basket

S&P500 Market data provider

## KDB Initialization

q.exe -p 5001

.u.upd:insert

basket:([] dt:"d"$(); tm:"t"$(); sym:`$(); px:"f"$(); vol:"i"$())

## Compilation

mix deps.get

cp config/rebar.config deps/qErlang

mix run --no-start

## Bootcamp run

bin/bootcamp.bat start

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `basket` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:basket, "~> 1.0.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/basket](https://hexdocs.pm/basket).
