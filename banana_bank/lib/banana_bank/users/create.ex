defmodule BananaBank.Users.Create do
  alias BananaBank.Users.User
  alias BananaBank.Repo
  alias BananaBank.ViaCep.Client, as: ViaCepClient

  def call(%{"cep" => cep} = params) do
    with {:ok, _result} <- ViaCepClient.call(cep) do #Se sucesso na validacao do cep, cria user
      params                                         #Se tiver erro, chama o fallbackcontroller p tratar
      |> User.changeset()
      |> Repo.insert()
    end
  end
end
