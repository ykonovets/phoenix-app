defmodule PhoenixBlog.User do
  use PhoenixBlog.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_many :comments, PhoenixBlog.Comment, on_delete: :delete_all

    timestamps
  end

  def full_name(model) do
    "#{model.first_name} #{model.last_name}"
  end

  def valid_password?(password, crypted), do: Comeonin.Bcrypt.checkpw(password, crypted)

  def by_email(email) do
    from u in PhoenixBlog.User, where: u.email == ^email
  end
  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def login_changeset(model) do
    model
    |> cast(%{}, ~w(), ~w(email password))
  end

  def login_changeset(model, params) do
    model
    |> cast(params, ~w(), ~w(email password))
    |> validate_password
  end

  def create_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(first_name last_name email password password_confirmation))
    |> validate_confirmation(:password)
    |> set_password_hash
  end

  def update_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(first_name last_name))
  end

  defp set_password_hash(changeset) do
    case Ecto.Changeset.fetch_change(changeset, :password) do
      { :ok, password } ->
        changeset
        |> Ecto.Changeset.put_change(:encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      :error -> changeset
    end
  end

  defp validate_password(changeset) do
    case Ecto.Changeset.get_field(changeset, :encrypted_password) do
      nil -> password_incorrect_error(changeset)
      crypted -> validate_password(changeset, crypted)
    end
  end

  defp validate_password(changeset, crypted) do
    password = Ecto.Changeset.get_change(changeset, :password)
    if valid_password?(password, crypted), do: changeset, else: password_incorrect_error(changeset)
  end

  defp password_incorrect_error(changeset), do: Ecto.Changeset.add_error(changeset, :password, "is incorrect")
end
