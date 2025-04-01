defmodule TwixWeb.SchemaTest do
  use TwixWeb.ConnCase, async: true

  describe "users query" do
    test "returns a user", %{conn: conn} do
      user_params = %{nickname: "jose", age: 22, email: "jose@frutas.com"}

      {:ok, user} = Twix.create_user(user_params)

      query = """
      {
        get_user(id: #{user.id}){
          nickname
          email
        }
      }
      """

      expected_response = %{
        "data" => %{"get_user" => %{"email" => "jose@frutas.com", "nickname" => "jose"}}
      }

      response =
        conn
        |> post("/api/graphql", %{query: query})
        # Retorno automatico do GraphQL é 200
        |> json_response(200)

      assert response == expected_response
    end

    test "when there is an error, returns the error", %{conn: conn} do
      query = """
      {
        get_user(id: 999){
          nickname
          email
        }
      }
      """

      expected_response = %{
        "data" => %{"get_user" => nil},
        "errors" => [
          %{
            "locations" => [%{"column" => 3, "line" => 2}],
            "message" => "not_found",
            "path" => ["get_user"]
          }
        ]
      }

      response =
        conn
        |> post("/api/graphql", %{query: query})
        # Retorno automatico do GraphQL é 200
        |> json_response(200)

      assert response == expected_response
    end
  end
end
