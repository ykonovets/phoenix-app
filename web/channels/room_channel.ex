defmodule PhoenixBlog.RoomChannel do
  use Phoenix.Channel
  import Guardian.Phoenix.Socket

  alias PhoenixBlog.User

  def join(_room, %{"guardian_token" => token}, socket) do
    case sign_in(socket, token) do
      {:ok, authed_socket, _guardian_params} ->
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

  def broadcast_change(toy) do
    payload = %{
      "name" => toy.name,
      "color" => toy.color,
      "age" => toy.age,
      "id" => toy.id
    }
    broadcast!("toys:#{toy.id}", "change", payload)
  end
end
