defmodule Market.Provider do
     use GenServer

     alias :rand, as: Rand
     alias :qErlang, as: Kdb

     def start_link( connection ) do
          GenServer.start_link( __MODULE__, [connection], name: :provider )
     end

     def init( [connection] ) do
          skew = ( Rand.uniform - 0.5 ) / 200
          timeout = 10000 + Rand.uniform( 50000 )
          timer = Process.send_after( self(), :tick, timeout )
          IO.inspect( skew, label: "Skew" )

          state = %{ connection: connection, skew: skew, timer: timer }

          { :ok, state }
     end

     defp query( socket, arg ) do
          GenServer.cast( :provider, { :query, arg } )
     end

     # callbacks
     def handle_info( :tick, state ) do
          skew = ( Rand.uniform - 0.5 ) / 200
          timeout = 10000 + Rand.uniform( 50000 )
          timer = Process.send_after( self(), :tick, timeout )

          IO.inspect( skew, label: "Skew" )

          { :noreply, %{ state | skew: skew, timer: timer } }
     end

     def handle_cast( { :query, date, time, symbol, price, volume }, state ) do
          with :ok <- Kdb.async( state.connection, { :char_list, to_charlist(
                    "`basket insert (#{date};#{time}0;`#{symbol};#{price + state.skew * price};#{volume})" ) } ) do

               { :noreply, state }
          else
               { :error, reason } -> IO.inspect( reason, label: "Error" )
          end
     end
end
