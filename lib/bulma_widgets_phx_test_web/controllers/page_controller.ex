defmodule BulmaWidgetsPhxTestWeb.PageController do
  use BulmaWidgetsPhxTestWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
