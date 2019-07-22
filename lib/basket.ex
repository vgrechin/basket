NimbleCSV.define( CSVParser, separator: "," )

defmodule Basket do
     use Application
     use Task

     alias :qErlang, as: Kdb
     alias Market.Constituent
     @snp500 "deps/SnP500s/data/constituents.csv"

     def start( _type, _args ) do
          { :ok, records } = File.read( @snp500 )

          basket = CSVParser.parse_string( records )
               |> Enum.map( fn [symbol, name, sector] ->
                         { String.to_atom( symbol ), %{ symbol: symbol, name: name, sector: sector } }
                    end )
               |> Map.new

          with { connection, _ } <- Kdb.open( '127.0.0.1', 5010, 'testusername', 'testpassword' ) do
               IO.inspect( connection, label: "Success" )
               Basket.Supervisor.start_link( connection )
               trade( basket )
          else
               { :error, reason } -> IO.inspect( reason, label: "Error" )
          end

          { :ok, self() }
     end

     defp spawn( { ticker, constituent },  accumulator ) do
          { :ok, pid } = GenServer.start( Constituent, { ticker, constituent } )
          Map.put( accumulator, ticker, pid )
     end

     defp trade( basket ) do
          constituents = Enum.reduce basket, %{}, &spawn/2
          Process.sleep( :infinity )
     end
end
