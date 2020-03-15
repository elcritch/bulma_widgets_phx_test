defmodule BulmaWidgets do
  import Phoenix.LiveView

  @doc """
  Imports various helpers to handle widget activations and state management.
  """
  defmacro __using__(_opts) do
    quote do
      import BulmaWidgets

      def handle_widget(socket, :update, id, updates) do
        socket
      end

      def handle_info({:widgets, :update, id, updates}, socket) do
        socket =
          socket
          |> widget_update(id, updates)
          |> handle_widget({:update, __MODULE__}, id, updates)
        {:noreply, socket}
      end

      def handle_info({:widgets, :deactivate_all}, socket) do
        {:noreply, socket |> widget_close_all()}
      end

      def handle_info({:widgets, :active, id, toggle}, socket) do
        socket =
          socket
          |> widget_close_all()
          |> widget_update(id, [active: toggle])

        {:noreply, socket}
      end

      defoverridable handle_widget: 4
    end
  end

  def widget_close_all(socket) do
    deactivate =
      socket.assigns
      |> Enum.filter(fn {_k, v} -> if is_list(v) do v[:__widget__] else false end; _ -> false end)
      |> Enum.map(fn {k, v} -> {k, v |> Keyword.put(:active, false)} end)

    socket |> assign(deactivate)
  end

  def widget_assign(socket, widget) do
    socket
    |> assign(%{widget[:id] => Keyword.put(widget, :__widget__, true)})
  end

  def widget_update(socket, id, updates) do
    socket
    |> assign(%{id => Keyword.merge(socket.assigns[id], updates)})
  end

end
