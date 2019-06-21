defmodule Market.Constituent do
     use gen_server

     def init( ticker ) when is_atom( ticker ) do
          state = %{ ticker: ticker }

          { :ok, state }
     end
end
