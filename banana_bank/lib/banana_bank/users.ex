defmodule BananaBank.Users do
  alias BananaBank.Users.Create
  defdelegate create(params), to: Create, as: :call #Users.create chama o Modulo Create na funcao call
end
