defmodule PhoenixBlog.PostLink do
  use PhoenixBlog.Web, :model

  schema "post_links" do
    field :title, :string
    field :link, :string
    field :_destroy, :boolean, virtual: true

    belongs_to :post, PhoenixBlog.Post

    timestamps
  end

  @required_fields ~w(title link)
  @optional_fields ~w(_destroy)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.s
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> set_destroy
  end

  def set_destroy(changeset) do
    if get_change(changeset, :_destroy) do
      %{changeset | action: :delete, valid?: true}
    else
      changeset
    end
  end
end
