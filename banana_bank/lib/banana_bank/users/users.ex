defmodule BananaBank.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @required_params [:name, :password_hash, :email, :cep]

  schema "users" do
    field :name, :string
    field :password_hash, :string
    field :email, :string
    field :cep, :string

    timestamps()
  end

  #Mapeamento e validacao de dados
  def changeset(user \\ %__MODULE__{}, params) do
    user
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:name, min: 3) #Nome precisa ter no minimo 3 caracteres
    |> validate_format(:email, ~r/@/) #Email precisa ter @
    |> validate_length(:cep, min: 8)

  end
end
