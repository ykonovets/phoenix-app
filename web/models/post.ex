defmodule PhoenixBlog.Post do
  use PhoenixBlog.Web, :model

  schema "posts" do
    field :title, :string
    field :text, :string

    has_many :post_links, PhoenixBlog.PostLink, on_delete: :delete_all
    has_many :comments, PhoenixBlog.Comment, on_delete: :delete_all
    belongs_to :author, PhoenixBlog.User, foreign_key: :user_id

    timestamps
  end

  @required_fields ~w(title text user_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def create_changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_assoc(:post_links)
  end

  def update_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(title text), @optional_fields)
    |> cast_assoc(:post_links)
  end
end
