NimbleCSV.define( CSVParser, separator: "," )

defmodule Basket do
     @constituents "deps/SnP500s/data/constituents.csv"

     alias :qErlang, as: Kdb

     def start( _type, _args ) do
          { :ok, contents } = File.read( @constituents )

          constituents = CSVParser.parse_string( contents )
               |> Enum.map( fn [symbol, name, sector] ->
                         { String.to_atom( symbol ), %{ symbol: symbol, name: name, sector: sector } }
                    end )
               |> Map.new

          IO.inspect( constituents, label: "Constituents", limit: :infinity )

          with { kdb, _ } <- Kdb.open( '127.0.0.1', 5001, 'testusername', 'testpassword', :infinity ) do
               IO.inspect( kdb, label: "Success" )
               query( kdb, "3.23 6.46" )
               Kdb.close( kdb )
          else
               { :error, reason } -> IO.inspect( reason, label: "Error" )
          end

          { :ok, self() }
     end

     defp query( socket, arg ) do
          with { :ok, { type, result } } <- Kdb.sync( socket, { :char_list, to_charlist( arg ) } ) do
               IO.inspect( { type, result }, label: "Result" )
          else
               { :error, reason } -> IO.inspect( reason, label: "Error" )
          end
     end
end
