defmodule PhoenixBlog.Api.V1.CommentView do
  use PhoenixBlog.Web, :view

  def render("create.json", %{comment: comment}) do
    comment
  end
end
