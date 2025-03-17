defmodule BananaBankWeb.UsersController do
  use BananaBankWeb, :controller

  alias BananaBank.Users
  alias Users.User

  action_fallback BananaBankWeb.FallbackController

  def create(conn, params) do
    with ({:ok, %User{} = user} <- Users.create(params)) do
      conn
      |> put_status(:created) #created = status 201
      |> render(:create, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    with ({:ok, %User{} = user} <- Users.get(id)) do
      conn
      |> put_status(:ok) #ok = status 200
      |> render(:get, user: user)
    end
  end
end
