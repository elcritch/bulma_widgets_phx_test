defmodule BulmaWidgetsPhxTestWeb.LiveController do
  use BulmaWidgetsPhxTestWeb, :controller
  require Logger

  import Phoenix.LiveView.Controller

  def index(conn, _params) do
    conn |> live_render(BulmaWidgetsPhxTestWeb.GalleryLive, session: %{})
  end

  def widget_example(conn, _params) do
    conn |> live_render(WidgetExampleLive, session: %{})
  end
end
