defmodule Market.Supervisor do
     use Supervisor
     alias Market.Provider

     def start_link do
          Supervisor.start_link( __MODULE__, [] )
     end

     def init( _ ) do
          children = [
               worker( Provider, [] )
          ]

          supervise( children, strategy: :one_for_one )
     end
end
