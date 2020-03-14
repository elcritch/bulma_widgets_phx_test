defmodule BulmaWidgets.DropdownComponent do
  use Phoenix.LiveComponent
  require Logger

  def update(assigns, socket) do
    Logger.info("dropdown component: assigns: #{inspect assigns }")
    Logger.info("dropdown component: keys: #{inspect socket.assigns }")
    assigns = assigns |> Map.merge(assigns.options |> Map.new)

    items =
      for {v, i} <- Enum.with_index(assigns.items) do
        {to_string(i), v}
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
              <a phx-value-key="<%= key %>" href="#" class="dropdown-item" phx-click="clicked" phx-target="#bulma-dropdown-<%= @id %>" >
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
    Logger.info("dropdown component: evt: #{inspect evt}")
    Logger.info("dropdown component: params: #{inspect params}")

    {_key, item} = socket.assigns.items |> List.keyfind(params["key"], 0)
    send self(), {:widgets, :dropdown, socket.assigns.id, item}
    {:noreply, socket}
  end

end
