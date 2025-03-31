defmodule TwixWeb.Schema.Types.Root do
  use Absinthe.Schema.Notation

  alias Crudry.Middlewares.TranslateErrors
  alias TwixWeb.Resolvers.User, as: UserResolver
  alias TwixWeb.Resolvers.Post, as: PostResolver

  import_types TwixWeb.Schema.Types.Post
  import_types TwixWeb.Schema.Types.User

  object :root_query do
    field :get_user, type: :user do
      arg :id, non_null(:id)
      resolve &UserResolver.get/2
    end
  end

  object :root_mutation do
    field :add_like_to_post, type: :post do
      arg :id, non_null(:id)

      resolve &PostResolver.add_like/2
      middleware TranslateErrors
    end

    field :create_post, type: :post do
      arg :input, non_null(:create_post_input)

      resolve &PostResolver.create/2
      middleware TranslateErrors
    end

    field :create_user, type: :user do
      arg :input, non_null(:create_user_input)

      resolve &UserResolver.create/2
      middleware TranslateErrors
    end

    field :update_user, type: :user do
      arg :input, non_null(:update_user_input)

      resolve &UserResolver.update/2
      middleware TranslateErrors
    end
  end
end
