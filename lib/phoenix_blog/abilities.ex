alias PhoenixBlog.User
alias PhoenixBlog.Post
alias PhoenixBlog.Comment

defimpl Canada.Can, for: User do
  def can?(%User{}, action, Post) when action in [:index, :new, :create], do: true
  def can?(%User{}, action, %Post{}) when action in [:create, :show], do: true
  def can?(%User{id: user_id}, action, %Post{user_id: user_id})
    when action in [:edit, :update, :delete], do: true

  def can?(%User{}, action, User) when action in [:index, :new, :create], do: true
  def can?(%User{}, action, %User{}) when action in [:show, :edit, :delete], do: true

  def can?(%User{}, :create, Comment), do: true

  def can?(_, _, _), do: false
end
