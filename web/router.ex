defmodule PhoenixBlog.Router do
  use PhoenixBlog.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  scope "api/v1/", PhoenixBlog.Api.V1 do
    pipe_through [:api, :api_auth]
    scope "/posts/:post_id" do
      resources "/comments", CommentController, only: [:create]
    end
  end

  scope "/", PhoenixBlog do
    pipe_through [:browser, :browser_auth] # Use the default browser stack
    resources "/posts", PostController
    resources "/users", UserController
    resources "/sessions", SessionController, singleton: true
    get "/", PostController, :index, as: :root
  end
end
