defmodule BulmaWidgets.TabsComponent do
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
      |> Map.put_new(:centered, false)
      |> Map.put_new(:index, items |> Enum.at(0) |> elem(0))
      |> Map.put_new(:selected, items |> Enum.at(0) |> elem(1))

    {:ok, socket |> assign(assigns) |> assign(items: items)}
  end

  def render(assigns) do
    ~L"""
      <div class="tabs widgets-tabs widgets-tabs-width <%= @classes %>"
           id="bulma-tabs-<%= @id %>" >
        <ul>
          <%= for {key, item} <- @items do %>
            <li href="#" class="tabs-item <%= if key == @index do 'is-active' end %>"
                phx-value-key="<%= key %>"
                phx-click="selected"
                phx-target="#bulma-tabs-<%= @id %>" >
              <a><%= item %></a>
            </li>
          <%= end %>
        </ul>
      </div>
      <div class="tabs-content ">
        <%= for {key, item} <- @items do %>
          <div style="<%= if key != @index do 'display: none;' end %>">
            <%= @inner_content.([item: item]) %>
          </div>
        <%= end %>
      </div>

    """
  end

  def handle_event("clicked", _params, socket) do
    send self(), {:widgets, :active, socket.assigns.id, !socket.assigns.active}
    {:noreply, socket}
  end

  def handle_event("selected", params, socket) do
    {key, item} = socket.assigns.items |> List.keyfind(params["key"], 0)
    send self(), {:widgets, {:update, __MODULE__}, socket.assigns.id, [index: key, selected: item]}
    send self(), {:widgets, :active, socket.assigns.id, false}
    {:noreply, socket}
  end

end
