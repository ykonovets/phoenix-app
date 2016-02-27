defmodule PhoenixBlog.SessionController do
  use PhoenixBlog.Web, :controller

  alias PhoenixBlog.User

  def unauthorized(conn) do
    conn
    |> put_flash(:error, "You are not authorized to perform this action")
    |> redirect(to: root_path(conn, :index))
  end

  def new(conn, _params) do
    changeset = User.login_changeset(%User{})
    render(conn, PhoenixBlog.SessionView, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    user = Repo.one(User.by_email(params["user"]["email"] || ""))
    if user && User.login_changeset(user, params["user"]).valid? do
      conn
      |> put_flash(:info, "Logged in.")
      |> Guardian.Plug.sign_in(user)
      |> redirect(to: post_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Email or password are incorrect")
      |> redirect(to: session_path(conn, :new))
    end
  end

  def delete(conn, _params) do
    Guardian.Plug.sign_out(conn)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: root_path(conn, :index))
  end
end
