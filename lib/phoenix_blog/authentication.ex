defmodule PhoenixBlog.Plug.Authenticate do
  use PhoenixBlog.Web, :controller
  import Plug.Conn

  alias PhoenixBlog.User

  def init(opts), do: opts

  def call(conn, _opts) do
    case Guardian.Plug.current_resource(conn) do
      nil ->
        conn |> redirect(to: session_path(conn, :new))
      user ->
        assign(conn, :current_user, user)
    end
  end
end
