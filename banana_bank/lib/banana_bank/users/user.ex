defmodule BananaBank.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset
  @required_params [:name, :password, :email, :cep]

  #@derive {Jason.Encoder, except: [:__meta__]} #Schema pode ser encodado em jason, apenas o nome (, only [:name])
  schema "users" do                            #tbm podendo ser (, except [__meta__]) exibe tudo menos __meta__, remove usersjson data()
    field :name, :string
    field :password, :string, virtual: true #virtual: true significa que nao existe no banco de dados
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
    |> add_password_hash()

  end

  defp add_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password)) #Retorna o password_hash criptografado
  end

  defp add_password_hash(changeset), do: changeset #Se o changeset for invalido retorna para nao salvar um erro
end
