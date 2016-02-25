defmodule PhoenixBlog.PostTest do
  use PhoenixBlog.ModelCase

  alias PhoenixBlog.Post

  @valid_attrs %{text: "some content", timestamps: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end
end
