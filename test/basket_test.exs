defmodule BasketTest do
  use ExUnit.Case
  alias Market.Constituent
  doctest Basket

  test "price the apple" do
    { :ok, pid } = GenServer.start( Constituent, { :AAPL, %{ symbol: "AAPL", name: "Apple Inc.", sector: "Information Technology" } } )

    assert Constituent.price( pid ) >= 10
  end
end
