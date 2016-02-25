defmodule PhoenixBlog.PostView do
  alias PhoenixBlog.Post
  alias PhoenixBlog.PostLink
  require Canada

  use PhoenixBlog.Web, :view

  def link_to_add_fields(title, form, fields_name, target) do
    changeset = Post.create_changeset(%Post{post_links: [%PostLink{}]})
    form = Phoenix.HTML.FormData.to_form(changeset, [])
    fields = render_to_string(__MODULE__, "post_link_fields.html", f: form)
    link "Add Link", to: "#", "data-template": fields, "data-target": target, class: "js-add-link-button"
  end
end
