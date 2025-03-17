defmodule BananaBankWeb.UsersJSON do
  alias BananaBank.Users.User
  def create(%{user: user}) do #http://localhost:4000/api/users 
    %{
      message: "User create with sucessfull",
      data: data(user)
    }
  end

  def get(%{user: user}), do: %{data: data(user)} #http://localhost:4000/api/users/:id  (num do ID)

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      cep: user.cep,
      email: user.email
    }
  end
end
