defmodule PhoenixBlog.Comment do
  use PhoenixBlog.Web, :model

  schema "comments" do
    field :text, :string

    belongs_to :post, PhoenixBlog.Post
    belongs_to :author, PhoenixBlog.User, foreign_key: :user_id

    timestamps
  end

  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.s
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w())
  end

  def create_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(post_id user_id text), @optional_fields)
  end
end
