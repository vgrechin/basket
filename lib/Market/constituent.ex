defmodule Market.Constituent do
     use GenServer
     alias :os, as: Os
     alias :rand, as: Rand

     def init( { ticker, constituent } ) do
          timeout = Rand.uniform( 1000 )
          timer = Process.send_after( self(), :tick, timeout )
          state = %{ ticker: ticker, constituent: constituent, timer: timer }

          { :ok, state }
     end

     def handle_info( :tick, state ) do
          timeout = Rand.uniform( 1000 )
          timer = Process.send_after( self(), :tick, timeout )
          IO.inspect( state.ticker, label: "Ticker")

          { :noreply, %{ state | timer: timer } }
     end
end
