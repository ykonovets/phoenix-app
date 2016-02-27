defmodule PhoenixBlog.ChannelNotifier do
  def notify_new_comment(comment) do
    PhoenixBlog.Endpoint.broadcast("comments", "comment:created", comment)
  end
end
