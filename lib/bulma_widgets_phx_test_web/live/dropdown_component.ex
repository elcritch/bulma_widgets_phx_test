defmodule BulmaWidgets.DropdownComponent do
  use Phoenix.LiveComponent
  require Logger

  defstruct id: nil, active: false, selected: nil, index: nil, items: []

  def update(assigns, socket) do
    items =
      for {v, i} <- Enum.with_index(assigns.items) do
        {to_string(i), v}
      end

    assigns =
      assigns
      # |> Map.merge(options |> Map.new)
      |> Map.put_new(:active, false)
      |> Map.put_new(:selected, items |> Enum.at(0) |> elem(1))
      |> Map.put_new(:index, items |> Enum.at(0) |> elem(0))

    {:ok, socket |> assign(assigns) |> assign(items: items)}
  end

  def render(assigns) do
    Logger.info("dropdown component: render: index: #{inspect assigns.index}")
    ~L"""
      <div class="dropdown <%= if @active do 'is-active' end %>"
           id="bulma-dropdown-<%= @id %>" >
        <div class="dropdown-trigger">
          <button class="button"
                  aria-haspopup="true"
                  aria-controls="bulma-dropdown-menu-<%= @id %>"
                  phx-click="clicked"
                  phx-target="#bulma-dropdown-<%= @id %>" >
            <span><%= if @selected do @selected else 'Dropdown' end %></span>
            <span class="icon is-small">
              <i class="fas fa-angle-down" aria-hidden="true"></i>
            </span>
          </button>
        </div>
        <div class="dropdown-menu" id="bulma-dropdown-menu-<%= @id %>" role="menu">
          <div class="dropdown-content">
            <%= for {key, item} <- @items do %>
              <a href="#" class="dropdown-item <%= if key == @index do 'is-active' end %>"
                  phx-value-key="<%= key %>"
                  phx-click="selected"
                  phx-target="#bulma-dropdown-<%= @id %>" >
                <%= item %>
              </a>
            <% end %>
          </div>
        </div>
      </div>
    """
  end

  def handle_event("clicked", params, socket) do
    Logger.info("dropdown component: evt: #{inspect "clicked"}")
    Logger.info("dropdown component: params: #{inspect params}")

    {:noreply, socket |> assign(active: ! socket.assigns.active)}
  end

  def handle_event(evt, params, socket) do
    Logger.info("dropdown component: evt: #{inspect evt}")
    Logger.info("dropdown component: params: #{inspect params}")

    {key, item} = socket.assigns.items |> List.keyfind(params["key"], 0)
    send self(), {:widgets, :dropdown, socket.assigns.id, [index: key, selected: item]}
    {:noreply, socket |> assign(active: false)}
  end

end
