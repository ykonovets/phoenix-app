defmodule PhoenixBlog.UserController do
  use PhoenixBlog.Web, :controller
  use Guardian.Phoenix.Controller

  alias PhoenixBlog.User

  plug :scrub_params, "user" when action in [:create, :update]
  plug PhoenixBlog.Plug.Authenticate
  plug :load_and_authorize_resource, model: User

  def index(conn, _params, current_user, claims) do
    render(conn, "index.html")
  end

  def new(conn, _params, current_user, claims) do
    changeset = User.login_changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}, current_user, claims) do
    changeset = User.create_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user, claims) do
    render(conn, "show.html", user: Repo.get!(User, id))
  end

  def edit(conn, %{"id" => id}, current_user, claims) do
    user = Repo.get!(User, id)
    changeset = User.update_changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}, current_user, claims) do
    user = Repo.get!(User, id)
    changeset = User.update_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user, claims) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
