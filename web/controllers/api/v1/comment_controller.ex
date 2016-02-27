defmodule PhoenixBlog.Api.V1.CommentController do
  use PhoenixBlog.Web, :controller
  use Guardian.Phoenix.Controller

  alias PhoenixBlog.Comment
  alias PhoenixBlog.Post

  plug :scrub_params, "comment" when action in [:create]
  plug PhoenixBlog.Plug.Authenticate
  plug :load_and_authorize_resource, model: Post, id_name: "post_id", persisted: true
  plug :load_and_authorize_resource, model: Comment

  def create(conn, %{"comment" => comment_params}, current_user, claims) do
    appended_params = Map.merge(comment_params, %{ "user_id" => current_user.id, "post_id" => conn.assigns.post.id})
    changeset = Comment.create_changeset(%Comment{}, appended_params)

    case Repo.insert(changeset) do
      {:ok, comment} ->
        PhoenixBlog.ChannelNotifier.notify_new_comment(comment |> Repo.preload(:author))
        send_resp(conn, :created, "")
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhoenixBlog.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
