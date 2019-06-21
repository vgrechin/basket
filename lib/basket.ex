NimbleCSV.define( CSVParser, separator: "," )

defmodule Basket do
     @snp500 "deps/SnP500s/data/constituents.csv"

     def start( _type, _args ) do
          Basket.Supervisor.start_link

          trade( @snp500 )

          { :ok, self() }
     end

     defp spawn( { ticker, constituent },  accumulator ) do
          { _result, pid } = GenServer.start( Market.Constituent, constituent )
          Map.put( accumulator, ticker, pid )
     end

     defp trade( index // @snp500 ) do
          { :ok, records } = File.read( index )

          basket = CSVParser.parse_string( records )
               |> Enum.map( fn [symbol, name, sector] ->
                         { String.to_atom( symbol ), %{ symbol: symbol, name: name, sector: sector } }
                    end )
               |> Map.new

          IO.inspect( basket, label: "Basket", limit: :infinity )

          constituents = Enum.reduce basket, %{}, &spawn/2
     end
end
