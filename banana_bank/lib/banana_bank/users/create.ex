defmodule BananaBank.Users.Create do
  alias BananaBank.Users.User
  alias BananaBank.Repo
  alias BananaBank.ViaCep.Client, as: ViaCepClient

  def call(%{"cep" => cep} = params) do
    # Se sucesso na validacao do cep, cria user
    with {:ok, _result} <- ViaCepClient.call(cep) do
      # Se tiver erro, chama o fallbackcontroller p tratar
      params
      |> User.changeset()
      |> Repo.insert()
    end
  end
end
