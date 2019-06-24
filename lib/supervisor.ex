defmodule Basket.Supervisor do
     use Supervisor

     def start_link( connection ) do
          Supervisor.start_link( __MODULE__, [connection] )
     end

     def init( [connection] ) do
          children = [
               supervisor( Market.Supervisor, [connection] )
          ]

          supervise( children, strategy: :one_for_all )
     end
end
