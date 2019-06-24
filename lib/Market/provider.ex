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
     def handle_cast( { :query, symbol, price }, state ) do
          #IO.inspect( {symbol, price}, label: "Query")
          IO.puts( "`basket insert (`#{symbol};#{price})" )
          with { :ok, { type, result } } <- Kdb.sync( state.connection, { :char_list, to_charlist( "`basket insert (`#{symbol};#{price})" ) } ) do
               IO.inspect( { type, result }, label: "Result" )
          else
               { :error, reason } -> IO.inspect( reason, label: "Error" )
          end

          { :noreply, state }
     end
end
