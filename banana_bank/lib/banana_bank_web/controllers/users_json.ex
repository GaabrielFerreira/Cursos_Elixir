defmodule BananaBankWeb.UsersJSON do
  alias BananaBank.Users.User
  def create(%{user: user}) do #http://localhost:4000/api/users
    %{
      message: "User created with sucessfull",
      data: data(user)
    }
  end

  def get(%{user: user}), do: %{data: user} #http://localhost:4000/api/users/:id  (num do ID)
  def update(%{user: user}), do: %{message: "User updated with sucessfull"} #http://localhost:4000/api/users/:id  (num do ID)

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      cep: user.cep,
      email: user.email
    }
  end
end
