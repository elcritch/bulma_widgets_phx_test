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
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BulmaWidgetsPhxTestWeb do
    # pipe_through [:browser, :dashboard_layout]
    pipe_through :browser

    get "/", PageController, :index
    live "/gallery.html", GalleryLive
    get "/gallery", LiveController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", BulmaWidgetsPhxTestWeb do
  #   pipe_through :api
  # end
end
