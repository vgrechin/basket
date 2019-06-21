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
               Kdb.close( kdb )
          else
               { :error, reason } -> IO.inspect( reason, label: "Error" )
          end

          { :ok, self() }
     end
end
