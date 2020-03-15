defmodule BulmaWidgets do
  import Phoenix.LiveView

  @doc """
  Imports various helpers to handle widget activations and state management.
  """
  defmacro __using__(_opts) do
    quote do
      import BulmaWidgets

      def handle_info({:widgets, :update, id, updates}, socket) do
        {:noreply, socket |> widget_update(id, updates)}
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
    end
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
