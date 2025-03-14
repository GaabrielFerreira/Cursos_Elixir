defmodule BananaBankWeb.UsersController do
  use BananaBankWeb, :controller

  alias BananaBankWeb.Users.Create

  def create(conn, params) do
    params
    |> Create.call()
    |> handle_response(conn)
  end

  defp handle_response({:ok, user}, conn) do
    conn
    |> put_status(:created) #:created = status 201
    |> render("user.json", user: user)
  end

  defp handle_response({:error, _changeset} = error, conn) do
    conn
    |> put_status(:bad_request) #:bad_request = status 400
    |> render("user.json", error: error)
  end
end
