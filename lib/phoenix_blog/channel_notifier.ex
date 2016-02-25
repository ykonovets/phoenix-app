defmodule PhoenixBlog.ChannelNotifier do
  alias PhoenixBlog.User
  
  def notify_new_comment(comment) do
    PhoenixBlog.Endpoint.broadcast("comments", "comment:created",
     %{ author: User.full_name(comment.author), text: comment.text})
  end
end
