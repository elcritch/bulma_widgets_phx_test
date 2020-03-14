defmodule BulmaWidgets.SelectComponent do
  use Phoenix.LiveComponent
  require Logger

  def update(assigns, socket) do

    Logger.warn("dropdown update: #{inspect assigns}")
    # {:ok, assign(socket, :user, user)}
    proplist? = Enum.all?(assigns.items, fn {_k, _v} -> true; _ -> false end)

    items =
      if proplist? do
        assigns.items |> Enum.to_list()
      else
        for {v, i} <- Enum.with_index(assigns.items) do {i, v} end
      end

    {:ok, socket |> assign(assigns) |> assign(items: items)}
  end

  def render(assigns) do
    ~L"""
      <div class="dropdown is-active"
           id="bulma-dropdown-<%= @id %>"
           >

        <div class="dropdown-trigger">
          <button class="button" aria-haspopup="true" aria-controls="bulma-dropdown-menu-<%= @id %>">
            <span>Click me</span>
            <span class="icon is-small">
              <i class="fas fa-angle-down" aria-hidden="true"></i>
            </span>
          </button>
        </div>
        <div class="dropdown-menu" id="bulma-dropdown-menu-<%= @id %>" role="menu">
          <div class="dropdown-content">
            <%= for {key, item} <- @items do %>
              <a phx-value-item="<%= key %>" href="#" class="dropdown-item" phx-click="clicked" phx-target="#bulma-dropdown-<%= @id %>" >
                <%= item %>
              </a>
            <% end %>
            <!-- <hr class="dropdown-divider"> -->
          </div>
        </div>
      </div>
    """
  end

  def handle_event(evt, params, socket) do
    Logger.info("select component: evt: #{inspect evt}")
    Logger.info("select component: params: #{inspect params}")

    params |> List.keyfind(1, 0)
    send self(), {:updated_select, socket.assigns.id}
    {:noreply, socket}
  end

end
