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
      |> assign(test_var: "value1")
      |> widget_assign(id: :dm_test1, items: [~E"<i>Menu 1</i>", "Menu 2"] )
      |> widget_assign(id: :dm_test2, items: ["Menu 1", "Menu 2"])
      |> widget_assign(id: :bw_tabs1)
      |> widget_assign(id: :bw_tabs2)

    Logger.warn "gallery select: assigns: #{inspect socket.assigns}"
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div phx-click="bulma-widgets-close-all" >
      <h1>LiveView is awesome!</h1>
      <section class="section">
        <h1 class="title">
          Bulma
        </h1>

        <p class="subtitle">
          Modern CSS framework based on <a href="https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox">Flexbox</a>
        </p>

        <div class="field">
          <div class="control">
            <input class="input" type="text" placeholder="Input">
          </div>
        </div>

        <h4>Normal HTML</h4>
        <div class="field">
          <p class="control">
            <span class="select">
              <select>
                <option>Select dropdown</option>
              </select>
            </span>
          </p>
        </div>
        <h4>Live Component</h4>

        <%= live_component @socket, TabsComponent, @bw_tabs1 ++ [
                items: ["Tab 1", "Tab 2"],
                classes: 'is-right'
            ] do %>
          <%= case @item do %>
            <%= "Tab 1" -> %>
              <h1>Tab1</h1>
              <%= live_component @socket, DropdownComponent, @dm_test1 %>
            <%= "Tab 2" -> %>
              <h1>Tab2</h1>
              <h2><%= @test_var %></h2>
          <% end %>
        <% end %>

        <%= live_component @socket, TabsComponent, @bw_tabs2 ++ [
                items: ["Info 1", "Info 2"],
                icons: %{"Info 1" => "fa fa-car"},
                classes: 'is-centered is-toggle is-toggle-rounded'
            ] do %>
          <%= case @item do %>
            <%= "Info 1" -> %>
              <h1>Info 2</h1>
            <%= "Info 2" -> %>
              <h1>Info 1</h1>
              <h2><%= @test_var %></h2>
              <%= live_component(@socket, DropdownComponent, @dm_test2) %>
          <% end %>
        <% end %>

        <a>
          <span class="icon is-small"><i class="fa fa-image" aria-hidden="true"></i></span>
          <span>Pictures</span>
        </a>

        <div class="buttons">
          <a class="button is-primary">Primary</a>
          <a class="button is-link">Link</a>
        </div>
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
    Logger.warn("updating widget: DropdownComponent: #{inspect {id, updates}}")
    socket
  end

  def handle_widget(socket, {:update, _module}, _id, _updates) do
    socket
  end

end
