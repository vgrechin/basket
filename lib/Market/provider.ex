defmodule Market.Provider do
     use GenServer

     alias :qErlang, as: Kdb

     def start_link( connection ) do
          GenServer.start_link( __MODULE__, [connection], name: :provider )
     end

     def init( [connection] ) do
          state = %{ connection: connection }

          { :ok, state }
     end

     defp query( socket, arg ) do
          GenServer.cast( :provider, { :query, arg } )
     end

     # callbacks
     def handle_cast( { :query, date, time, symbol, price, volume }, state ) do
          query = ".u.upd[`basket;(#{time}00;`#{symbol};#{price};#{volume})]"
          IO.inspect( query, label: "Query" )
          with { :ok, { type, result } } <- Kdb.sync( state.connection, { :char_list, to_charlist(
                    query ) } ) do
               { :noreply, state }
          else
               { :error, reason } -> IO.inspect( reason, label: "Error" )
          end
     end
end
