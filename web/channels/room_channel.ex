defmodule PhoenixBlog.RoomChannel do
  use Phoenix.Channel
  import Guardian.Phoenix.Socket

  alias PhoenixBlog.User
  alias Guardian.Phoenix.Socket

  intercept ["comment:created"]

  def join(_room, %{"guardian_token" => token, "post_id" => post_id}, socket) do
    case sign_in(socket, token) do
      {:ok, authed_socket, _guardian_params} ->
        {post_id, _} = Integer.parse(post_id)
        authed_socket = assign(authed_socket, :post_id, post_id)
        send(self, {:after_join, current_resource(authed_socket)})
        {:ok, authed_socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def join("rooms:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info({:after_join, user}, socket) do
    push socket, "joined", %{}
    broadcast!(socket, "user:connected", %{name: User.full_name(user)})
    {:noreply, socket}
  end

  def handle_out("comment:created", comment, socket) do
    user = Socket.current_resource(socket)
    if comment.post_id == socket.assigns.post_id do
      push socket, "comment:created", %{ author: User.full_name(comment.author), text: comment.text}
    end
    {:noreply, socket}
  end
end
