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

  describe "users mutation" do
    test "when all params are valid, creates the user", %{conn: conn} do
      query = """
      mutation {
        createUser(input: {nickname: "Gaaa", email: "gaaa@frutas.com", age: 19}) {
          id
          nickname
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        # Retorno automatico do GraphQL é 200
        |> json_response(200)

      assert %{"data" => %{"createUser" => %{"id" => _id, "nickname" => "Gaaa"}}} = response
    end
  end

  describe "subscriptions" do
    test "new follow", %{socket: socket} do
      user_params = %{nickname: "jose1", age: 22, email: "jose1@frutas.com"}
      {:ok, user1} = Twix.create_user(user_params)

      user_params = %{nickname: "jose2", age: 22, email: "jose2@frutas.com"}
      {:ok, user2} = Twix.create_user(user_params)

      mutation = """
        mutation{
          addFollower(input: {userId: #{user1.id}, followerId: #{user2.id}}) {
            followerId
            followingId
          }
        }
      """

      subscription = """
        subscription{
          newFollow{
            followerId
            followingId
          }
        }
      """

      # Setup da subscription
      socket_ref = push_doc(socket, subscription)
      assert_reply(socket_ref, :ok, %{subscriptionId: subscription_id})

      # Setup da mutation
      socket_ref = push_doc(socket, mutation)
      assert_reply(socket_ref, :ok, mutation_response)

      expected_response = %{
        data: %{"addFollower" => %{"followerId" => "#{user2.id}", "followingId" => "#{user1.id}"}}
      }

      assert mutation_response == expected_response

      assert_push("subscription:data", subscription_response)

      expected_sub_response = %{
               result: %{
                 data: %{
                   "newFollow" => %{"followerId" => "#{user2.id}", "followingId" => "#{user1.id}"}
                 }
               },
               subscriptionId: "#{subscription_id}"
             }

      assert subscription_response == expected_sub_response
    end
  end
end
