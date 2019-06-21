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

          case Kdb.open( '127.0.0.1', 5001, '', '', 1000 ) do
               { :error, reason } -> IO.inspect( reason, label: "Error" )
               { kdb, _ } ->
                    IO.inspect( kdb, label: "Success" )
                    Kdb.close( kdb )
          end

          { :ok, self() }
     end
end
