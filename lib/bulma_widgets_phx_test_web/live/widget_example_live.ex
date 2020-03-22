defmodule WidgetExampleLive do
  use BulmaWidgets
  alias BulmaWidgets.DropdownComponent
  alias BulmaWidgets.TabsComponent
  use Phoenix.LiveView
  require Logger

  def mount(_params, _session, socket) do
    socket = socket |> assign(test_var: "some example value")
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
              items: ["Menu 1", "Menu 2"] %>

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
                      items: ["Item 1", "Item 2"]) %>

              <% other -> %>

                <h1><%= other %></h1>

            <% end %>
          <% end %>
      </section>

      <style>
        .bulma-widgets-dropdown-width {
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

end
