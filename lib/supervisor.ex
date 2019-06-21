defmodule Basket.Supervisor do
     use Supervisor

     def start_link do
          Supervisor.start_link( __MODULE__, [] )
     end

     def init( _ ) do
          children = [
               supervisor( Market.Supervisor, [] )
          ]

          supervisor( children, strategy: :one_for_all )
     end
end
