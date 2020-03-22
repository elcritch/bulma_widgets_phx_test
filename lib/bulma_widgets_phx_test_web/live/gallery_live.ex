defmodule BulmaWidgetsPhxTestWeb.GalleryLive do
  alias BulmaWidgets.DropdownComponent
  alias BulmaWidgets.TabsComponent
  require Logger
  use Phoenix.LiveView
  import Phoenix.HTML
  use BulmaWidgets
  # use Phoenix.LiveView,
  # layout: {BulmaWidgetsPhxTestWeb.LayoutView, "app.html"}

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(test_var: "example value")

    Logger.info("gallery select: assigns: #{inspect(socket.assigns)}")
    Process.send_after(self(), :update_tabs, 10_000)
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div phx-click="bulma-widgets-close-all" >
      <h1>LiveView is awesome!</h1>
      <section class="section">
        <h1 class="title"> Bulma Widget </h1>

        <%= live_component @socket, DropdownComponent,
              id: :dm_test1,
              items: [~E"<i>Menu 1</i>", "Menu 2"] %>

        <div class="box">
          <%= live_component @socket, TabsComponent,
                  id: :bw_tabs2,
                  items: ["Info 1", "Info 2"],
                  icons: %{"Info 1" => "fa fa-car"},
                  classes: 'is-centered is-toggle is-toggle-rounded' do %>

            <%= case @item do %>

              <% "Info 1" -> %>
                <h1 class="title">First Tab</h1>

              <% "Info 2" -> %>

                <h1 class="title">Second Tab</h1>
                <h2 class="subtitle"><%= @test_var %></h2>

                <%= live_component(@socket, DropdownComponent,
                      id: :dm_test2,
                      items: ["Menu 1", "Menu 2"]) %>

              <% other -> %>

                <h1><%= other %></h1>

            <% end %>
          <% end %>
      </section>

      <style>
        .widgets-dropdown-width {
          width: 12em;
        }
      </style>
    </div>
    """
  end

  def handle_widget(socket, {:update, BulmaWidgets.DropdownComponent}, id, updates) do
    Logger.warn("updating widget: DropdownComponent: #{inspect({id, updates})}")
    socket
  end

  def handle_widget(socket, {:update, _module}, _id, _updates) do
    socket
  end

  def handle_info(:update_tabs, socket) do
    Logger.warn("update tabs message: #{inspect(:update_tabs)}")
    send_update(TabsComponent, id: :bw_tabs2, items: ["Info 1", "Info 2", "Info 3"])
    {:noreply, socket}
  end

  def handle_info(msg, socket) do
    Logger.warn("unhandled message: #{inspect(msg)}")
    {:noreply, socket}
  end
end
