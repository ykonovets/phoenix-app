defmodule PhoenixBlog.PostController do
  use PhoenixBlog.Web, :controller
  use Guardian.Phoenix.Controller

  alias PhoenixBlog.Post
  alias PhoenixBlog.Comment

  plug :scrub_params, "post" when action in [:create, :update]
  plug PhoenixBlog.Plug.Authenticate
  plug :load_and_authorize_resource, model: Post, preload: [:post_links, :author, comments: :author]

  def index(conn, _params, current_user, claims) do
    render(conn, "index.html")
  end

  def new(conn, _params, current_user, claims) do
    changeset = Post.create_changeset(%Post{})
    render(conn, "new.html", changeset: changeset, body_class: "post-add-edit-page")
  end

  def create(conn, %{"post" => post_params}, current_user, claims) do
    changeset = Post.create_changeset(%Post{}, Map.put(post_params, "user_id", current_user.id))

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, body_class: "post-add-edit-page")
    end
  end

  def show(conn, %{"id" => id}, current_user, claims) do
    comment_changeset = Comment.changeset(%Comment{})
    render(conn, "show.html", comment_changeset: comment_changeset, body_class: "post-show-page")
  end

  def edit(conn, %{"id" => id}, current_user, claims) do
    changeset = Post.update_changeset(conn.assigns.post)
    render(conn, "edit.html", post: conn.assigns.post, changeset: changeset, body_class: "post-add-edit-page")
  end

  def update(conn, %{"id" => id, "post" => post_params}, current_user, claims) do
    post = Repo.get!(Post, id) |> Repo.preload(:post_links)
    changeset = Post.update_changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset, body_class: "post-add-edit-page")
    end
  end

  def delete(conn, %{"id" => id}, current_user, claims) do
    Repo.delete!(conn.assigns.post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
end
