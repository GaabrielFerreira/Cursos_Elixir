defmodule BananaBank.Users.Verify do
  alias BananaBank.Users
  
  def call(%{"id" => id, "password" => password}) do
    case Users.get(id) do
      {:ok, user} -> verify(user, password)
      {:error, _} = error -> error #Se id for invalido
    end
  end

  defp verify(user, password) do
    case  Argon2.verify_pass(password, user.password_hash) do
      true -> {:ok, user} #Se a senha for valida
      false -> {:error, :unauthorized} #Se a senha for invalida
    end
  end
end
