defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  describe "create/2" do
    test "successfully creates an user", %{conn: conn} do
      params = %{
        name: "Joao",
        cep: "12345678",
        email: "joao@frutas.com",
        password: "123456"
      }

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:created)

      assert %{
        "data" => %{"cep" => "12345678", "email" => "joao@frutas.com", "id" => _id, "name" => "Joao"},
       "message" => "User created with successful"
      } = response
    end

    test "where there are invalid params, returns an error", %{conn: conn} do
      params = %{
        name: nil,
        cep: "123",
        email: "joao@frutas.com",
        password: "123"
      }

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:bad_request)

      expected_response = %{"error" => %{"cep" => ["should be 8 character(s)"], "name" => ["can't be blank"], "password" => ["should be at least 6 character(s)"]}}

      assert response == expected_response
    end
  end
end
