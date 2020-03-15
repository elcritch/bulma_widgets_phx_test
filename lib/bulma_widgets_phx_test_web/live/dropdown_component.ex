defmodule BulmaWidgets.DropdownComponent do
  use Phoenix.LiveComponent
  require Logger

  defstruct id: nil, active: false, selected: nil, index: nil, items: []

  def update(assigns, socket) do
    items =
      for {v, i} <- Enum.with_index(assigns.items) do
        {"#{i}-idx", v}
      end

    assigns =
      assigns
      |> Map.put(:module, __MODULE__)
      |> Map.put_new(:active, false)
      |> Map.put_new(:icon, 'fa fa-angle-down')
      |> Map.put_new(:index, items |> Enum.at(0) |> elem(0))
      |> Map.put_new(:selected, items |> Enum.at(0) |> elem(1))

    {:ok, socket |> assign(assigns) |> assign(items: items)}
  end

  def render(assigns) do
    ~L"""
      <div class="dropdown widgets-dropdown widgets-dropdown-width <%= if @active do 'is-active' end %>"
           id="bulma-dropdown-<%= @id %>" >
        <div class="dropdown-trigger widgets-dropdown-width ">
          <button class="button widgets-dropdown-width "
                  aria-haspopup="true"
                  aria-controls="bulma-dropdown-menu-<%= @id %>"
                  phx-click="clicked"
                  phx-target="#bulma-dropdown-<%= @id %>" >
            <span><%= if @selected do @selected else 'Dropdown' end %></span>
            <span class="icon is-small">
              <i class="<%= @icon %>" aria-hidden="true"></i>
            </span>
          </button>
        </div>
        <div class="dropdown-menu widgets-dropdown-width " id="bulma-dropdown-menu-<%= @id %>" role="menu">
          <div class="dropdown-content widgets-dropdown-width ">
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

  def handle_event("clicked", _params, socket) do
    send(self(), {:widgets, :active, socket.assigns.id, !socket.assigns.active})
    {:noreply, socket}
  end

  def handle_event("selected", params, socket) do
    {key, item} = socket.assigns.items |> List.keyfind(params["key"], 0)

    send(
      self(),
      {:widgets, {:update, __MODULE__}, socket.assigns.id, [index: key, selected: item]}
    )

    send(self(), {:widgets, :active, socket.assigns.id, false})
    {:noreply, socket}
  end
end
