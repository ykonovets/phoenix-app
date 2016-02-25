defmodule PhoenixBlog.LayoutView do
  use PhoenixBlog.Web, :view

  def authenticated?(conn) do
     Guardian.Plug.authenticated?(conn)
  end
end
