defmodule BananaBankWeb.UsersJSON do
  alias BananaBank.Users.User
  def create(%{user: user}) do #http://localhost:4000/api/users
    %{
      message: "User created successfully",
      data: data(user)
    }
  end

  def login(%{token: token}) do
    %{
      message: "User authenticated successfully",
      bearer: token
    }
  end

  def get(%{user: user}), do: %{data: data(user)} #http://localhost:4000/api/users/:id  (num do ID)
  def update(%{user: user}), do: %{message: "User updated successfully", data: data(user)} #http://localhost:4000/api/users/:id  (num do ID)
  def delete(%{user: user}), do: %{message: "User deleted successfully", data: data(user)}

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      cep: user.cep,
      email: user.email
    }
  end
end
