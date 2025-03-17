defmodule BananaBank.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset

  @required_params_create [:name, :password, :email, :cep]
  @required_params_update [:name, :email, :cep]

  #@derive {Jason.Encoder, except: [:__meta__]} #Schema pode ser encodado em jason, apenas o nome (, only [:name])
  schema "users" do                            #tbm podendo ser (, except [__meta__]) exibe tudo menos __meta__, remove usersjson data()
    field :name, :string
    field :password, :string, virtual: true #virtual: true significa que nao existe no banco de dados
    field :password_hash, :string
    field :email, :string
    field :cep, :string

    timestamps()
  end

  #Mapeamento e validacao de dados do usuario
  def changeset(params) do #(CREATE) se receber struct vazia, executa esse changeset
    %__MODULE__{} #Inicia com uma struct vazia
    |> cast(params, @required_params_create)
    |> do_validations(@required_params_create) #rq_params_create como field para do_validations
    |> add_password_hash()
  end

  def changeset(user, params) do #(UPDATE) se receber struct com dados, executa esse changeset
    user
    |> cast(params, @required_params_create) #Utilizar rq_parms_create para fazer o cast caso tbm receba o password no update
    |> do_validations(@required_params_update) #rq_params_update como field para do_validations
    |> add_password_hash()
  end

  defp do_validations(changeset, fields) do
    changeset
    |> validate_required(fields)
    |> validate_length(:name, min: 3) #Nome precisa ter no minimo 3 caracteres
    |> validate_format(:email, ~r/@/) #Email precisa ter @
    |> validate_length(:cep, is: 8) #Cep precisa ter 8 caracteres
  end

  defp add_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password)) #Retorna o password_hash criptografado
  end

  defp add_password_hash(changeset), do: changeset #Se o changeset for invalido retorna para nao salvar um erro
end
