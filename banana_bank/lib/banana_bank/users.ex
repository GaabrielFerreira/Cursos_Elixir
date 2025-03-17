defmodule BananaBank.Users do

  alias BananaBank.Users.Create
  alias BananaBank.Users.Get #alias separado para facilitar busca

  defdelegate create(params), to: Create, as: :call #Users.create chama o Modulo Create na funcao call
  defdelegate get(params), to: Get, as: :call #Users.Get chama o Modulo get na funcao call
end
