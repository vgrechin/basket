defmodule Market.Provider do
     use GenServer

     alias :qErlang, as: Kdb

     def init() do
          state = %{ connection: open() }

          { :ok, state }
     end

     defp open()
          with { kdb, _ } <- Kdb.open( '127.0.0.1', 5001, 'testusername', 'testpassword' ) do
               IO.inspect( kdb, label: "Success" )
               query( kdb, "select avg px,avg vol by sym from trades" )
               Kdb.close( kdb )
          else
               { :error, reason } -> IO.inspect( reason, label: "Error" )
          end
     end

     defp query( socket, arg ) do
          with { :ok, { type, result } } <- Kdb.sync( socket, { :char_list, to_charlist( arg ) } ) do
               IO.inspect( { type, result }, label: "Result" )
          else
               { :error, reason } -> IO.inspect( reason, label: "Error" )
          end
     end


     # callbacks
     def handle_call( :id, _from, state ) do
          { :reply, state, state }
     end

     def handle_cast( :query, state ) do
          { :noreply, state }
     end
end
