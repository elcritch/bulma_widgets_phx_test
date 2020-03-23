defmodule BulmaWidgetsPhxTestWeb.GalleryLive do
  alias BulmaWidgets.DropdownComponent
  alias BulmaWidgets.TabsComponent
  alias BulmaWidgets.ModalComponent
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
      |> assign(modal_var: "modal test data")

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

      <section class="section">
        <button class="button is-primary " aria-label="open" phx-click="open-modal-1">Open First Modal</button>
        <button class="button is-primary " aria-label="open" phx-click="open-modal-2">Open Second Modal</button>

        <!-- modal using default title and footers -->
        <%= live_component @socket, ModalComponent, id: :modal1,
                title: "First Modal",
                footer: %{ok: "Save", ok_classes: "is-warning", cancel: "Cancel" }
            do %>

          <%= case @item do %>
            <% :content -> %>
              <h2 class="title">Hello World</h2>
              <h4 class="title">var: <%= @modal_var %></h4>
              <p> Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla accumsan. </p>
          <% end %>
        <% end %>

        <!-- modal using explicit custom title and footers -->
        <%= live_component @socket, ModalComponent, id: :modal2 do %>
          <%= case @item do %>
            <% :header -> %>
              <p class="modal-card-title">Second Modal</p>
              <button class="delete" phx-click="delete" phx-target="<%= @target %>" aria-label="close">

            <% :content -> %>
              <h2 class="title">Hello World</h2>
              <p> Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla accumsan. </p>

            <% :footer -> %>
              <button class="button is-success" phx-click="modal-2-save" >
                Save changes
              </button>
              <button class="button" phx-click="cancel" phx-target="<%= @target %>">
                Cancel
              </button>
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

  def handle_widget(socket, {:update, _module}, _id, _updates) do
    socket
  end

  def handle_event("open-modal-1", _params, socket) do
    {:noreply, socket |> widget_open(:modal1)}
  end

  def handle_event("modal-1-save", _params, socket) do
    {:noreply, socket |> widget_close(:modal1)}
  end

  def handle_event("open-modal-2", _params, socket) do
    {:noreply, socket |> widget_open(:modal2)}
  end

  def handle_event("modal-2-save", _params, socket) do
    {:noreply, socket |> widget_close(:modal2)}
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
