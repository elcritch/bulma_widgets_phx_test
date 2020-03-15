defmodule BulmaWidgetsPhxTestWeb.GalleryLive do

  alias BulmaWidgets.DropdownComponent
  require Logger
  use Phoenix.LiveView
  import Phoenix.HTML
  # use Phoenix.LiveView,
    # layout: {BulmaWidgetsPhxTestWeb.LayoutView, "app.html"}

  def mount(_params, _session, socket) do

    socket =
      socket
      |> widget_assign(id: :dm_test1, items: [~E"<i>Menu 1</i>", "Menu 2"])
      |> widget_assign(id: :dm_test2, items: ["Menu 1", "Menu 2"])

    Logger.warn "gallery select: assigns: #{inspect socket.assigns}"
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
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
        <%= live_component @socket, DropdownComponent, @dm_test1 %>
        <%= live_component @socket, DropdownComponent, @dm_test2 %>

        <div class="buttons">
          <a class="button is-primary">Primary</a>
          <a class="button is-link">Link</a>
        </div>
      </section>
    """
  end

  def handle_info({:widgets, :dropdown, id, msg}, socket) do

    Logger.info "updated select: #{inspect {id, msg}}"
    Logger.info "updated select: #{inspect {id, socket.assigns[id]}}"
    Logger.info "updated select: merged: #{inspect {id, Keyword.merge(msg, socket.assigns[id])}}"
    socket =
     socket
     |> widget_update(id, msg)

    {:noreply, socket}
  end

  def handle_info({:widgets, :active, id, toggle}, socket) do
    deactivate =
      socket.assigns
      |> Enum.filter(fn {_k, v} -> if is_list(v) do v[:__widget__] else false end; _ -> false end)
      |> Enum.map(fn {k, v} -> {k, v |> Keyword.put(:active, false)} end)

    socket =
      socket
      |> assign(deactivate)
      |> widget_update(id, [active: toggle])

    {:noreply, socket}
  end

  def widget_assign(socket, widget) do
    socket
    |> assign(%{widget[:id] => widget |> Keyword.put(:__widget__, true)})
  end

  def widget_update(socket, id, updates) do
    socket
    |> assign(%{id => Keyword.merge(socket.assigns[id], updates)})
  end
end
