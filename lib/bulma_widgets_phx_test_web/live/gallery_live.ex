defmodule BulmaWidgetsPhxTestWeb.GalleryLive do

  require Logger
  use Phoenix.LiveView
  # use Phoenix.LiveView,
    # layout: {BulmaWidgetsPhxTestWeb.LayoutView, "app.html"}

  def mount(_params, _session, socket) do

    socket =
      socket
      |> assign(dm_test1: [selected: "Menu 1", index: 0, items: ["Menu 1", "Menu 2"]])
      |> assign(dm_test2: [selected: "Menu 1", index: 0, items: ["Menu 1", "Menu 2"]])

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
        <%= live_component @socket, BulmaWidgets.DropdownComponent, id: :dm_test1, options: @dm_test1 %>
        <%= live_component @socket, BulmaWidgets.DropdownComponent, id: :dm_test2, options: @dm_test2 %>

        <div class="buttons">
          <a class="button is-primary">Primary</a>
          <a class="button is-link">Link</a>
        </div>
      </section>

    """
  end

  def handle_info({:widgets, :dropdown, id, msg}, socket) do

    Logger.info "updated select: #{inspect {id, msg}}"
    {:noreply, socket}
  end

end
