defmodule Market.Supervisor do
     use Supervisor
     alias Market.Provider

     def start_link( connection ) do
          Supervisor.start_link(__MODULE__, [connection], name: __MODULE__)
     end

     def init( [connection] ) do
          children = [
               worker( Provider, [connection] )
          ]

          supervise( children, strategy: :one_for_one )
     end
end
