NimbleCSV.define( CSVParser, separator: "," )

defmodule Basket do
     @constituents "deps/SnP500s/data/constituents.csv"

     def start( _type, _args ) do
          { :ok, contents } = File.read( @constituents )

          constituents = CSVParser.parse_string( contents )
               |> Enum.map( fn [symbol, name, sector] ->
                         { String.to_atom( symbol ), %{ symbol: symbol, name: name, sector: sector } }
                    end )
               |> Map.new

          IO.inspect( constituents, label: "Constituents", limit: :infinity )

          { :ok, self() }
     end
end
