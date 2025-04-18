defmodule BananaBankWeb.UsersController do
  use BananaBankWeb, :controller

  alias BananaBank.Users
  alias Users.User
  
  alias BananaBankWeb.Token

  action_fallback BananaBankWeb.FallbackController

  def create(conn, params) do
    with ({:ok, %User{} = user} <- Users.create(params)) do
      conn
      |> put_status(:created) #created = status 201
      |> render(:create, user: user)
    end
  end

  def delete(conn, id) do
    with ({:ok, %User{} = user} <- Users.delete(id)) do
      conn
      |> put_status(:ok) #ok = status 200
      |> render(:delete, user: user)
    end
  end


  def login(conn, params) do
    with ({:ok, %User{} = user} <- Users.login(params)) do
      token = Token.sign(user)

      conn
      |> put_status(:ok) #ok = status 200
      |> render(:login, token: token)
    end
  end

  def show(conn, %{"id" => id}) do
    with ({:ok, %User{} = user} <- Users.get(id)) do
      conn
      |> put_status(:ok) #ok = status 200
      |> render(:get, user: user)
    end
  end

  def update(conn, params) do
    with ({:ok, %User{} = user} <- Users.update(params)) do
      conn
      |> put_status(:ok) #ok = status 200
      |> render(:update, user: user)
    end
  end
end
