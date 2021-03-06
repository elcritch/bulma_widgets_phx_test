defmodule BulmaWidgetsPhxTestWeb.Router do
  use BulmaWidgetsPhxTestWeb, :router

  pipeline :dashboard_layout do
    plug :put_layout, {BulmaWidgetsPhxTestWeb.LayoutView, :app}
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {BulmaWidgetsPhxTestWeb.LayoutView, :app}
    plug Plug.RequestId
    plug Plug.Logger
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BulmaWidgetsPhxTestWeb do
    # pipe_through [:browser, :dashboard_layout]
    pipe_through :browser

    # get "/", PageController, :index
    get "/", LiveController, :index
    get "/example", LiveController, :widget_example
    # get "/gallery", LiveController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", BulmaWidgetsPhxTestWeb do
  #   pipe_through :api
  # end
end
