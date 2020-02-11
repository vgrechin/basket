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
          milliseconds = Integer.floor_div( elem( time.microsecond, 0 ), 1000 )
          with :ok <- Kdb.async( state.connection, { :mixed_list, [
               { :symbol, <<".u.upd">> },
               { :symbol, <<"basket">> },
               { :mixed_list, [
                    { :date, Kdb.date_to_int( date ) },
                    { :time, Kdb.time_to_int( { time.hour, time.minute, time.second }, milliseconds ) },
                    { :symbol, <<"#{symbol}">> },
                    { :float, price + state.skew * price },
                    { :int, volume } ] } ] } ) do

               { :noreply, state }
          else
               { :error, reason } -> IO.inspect( reason, label: "Error" )
          end
     end
end
