defmodule Market.Constituent do
     use GenServer
     alias :rand, as: Rand

     def init( { ticker, constituent } ) do
          price = 10 + Rand.uniform( 990 )
          timeout = Rand.uniform( 1000 )
          timer = Process.send_after( self(), :tick, timeout )
          state = %{ ticker: ticker, price: price, constituent: constituent, timer: timer }

          { :ok, state }
     end

     def price( process_id ) do
          GenServer.call( process_id, { :price } )
     end

     def handle_info( :tick, state ) do
          timeout = Rand.uniform( 1000 )
          timer = Process.send_after( self(), :tick, timeout )
          price = state.price + ( Rand.uniform - 0.5 ) * state.price / 100
          GenServer.cast( :provider, { :query, state.constituent.symbol, price } )

          { :noreply, %{ state | price: price, timer: timer } }
     end

     def handle_call( :price, _from, state ) do
          { :reply, state.price, state }
     end
end
