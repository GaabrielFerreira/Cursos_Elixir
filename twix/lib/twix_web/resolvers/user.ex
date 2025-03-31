defmodule TwixWeb.Resolvers.User do
  #Primeiro parametro sao os arg da query em um map
  def get(%{id: id}, _context), do: Twix.get_user(id)
  def create(%{input: params}, _context), do: Twix.create_user(params)
  def update(%{input: params}, _context), do: Twix.update_user(params)

  def add_follower(%{input: %{user_id: user_id, follower_id: follower_id}}, _context) do
    result = Twix.add_follower(user_id, follower_id)
    Absinthe.Subscription.publish(TwixWeb.Endpoint, result, new_follower: "new_follow_to_topic")

    result
  end
end
