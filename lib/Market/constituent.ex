defmodule Market.Constituent do
     use GenServer
     alias :rand, as: Rand

     def init( { ticker, constituent } ) do
          price = 10 + Rand.uniform( 990 )
          volume = 100 + 100 * Rand.uniform( 100 )

          timeout = Rand.uniform( 100 )
          timer = Process.send_after( self(), :tick, timeout )
          state = %{ ticker: ticker, price: price, volume: volume, constituent: constituent, timer: timer }

          { :ok, state }
     end

     def price( process_id ) do
          GenServer.call( process_id, { :price } )
     end

     def handle_info( :tick, state ) do
          today = NaiveDateTime.utc_now
          date = {today.year, today.month, today.day}
          time = today |> NaiveDateTime.truncate( :millisecond ) |> NaiveDateTime.to_time()
          price = state.price + ( Rand.uniform - 0.5 ) * state.price / 100
          volume = 100 + 100 * Rand.uniform( 100 )

          timeout = Rand.uniform( 100 )
          timer = Process.send_after( self(), :tick, timeout )
          GenServer.cast( :provider, { :query, date, time, state.constituent.symbol, price, volume } )

          { :noreply, %{ state | price: price, volume: volume, timer: timer } }
     end

     def handle_call( { :price }, _from, state ) do
          { :reply, state.price, state }
     end
end
