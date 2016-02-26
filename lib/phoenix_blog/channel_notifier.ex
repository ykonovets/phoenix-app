defmodule PhoenixBlog.ChannelNotifier do
  alias PhoenixBlog.User

  def notify_new_comment(comment) do
    PhoenixBlog.Endpoint.broadcast("comments", "comment:created", comment)
  end
end
