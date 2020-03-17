defmodule BulmaWidgets do
  import Phoenix.LiveView
  require Logger

  @doc """
  Imports various helpers to handle widget activations and state management.
  """
  defmacro __using__(_opts) do
    quote do
      import BulmaWidgets

      def handle_widget(socket, :update, id, updates) do
        socket
      end

      def handle_event("bulma-widgets-close-all", _params, socket) do
        {:noreply, socket |> widget_close_all()}
      end

      def handle_info({:widgets, :register, widget}, socket) do
        {:noreply, socket |> widget_register(widget)}
      end

      def handle_info({:widgets, :active, id, toggle}, socket) do
        {:noreply, socket |> widget_close_all(except: {id, toggle})}
      end

      defoverridable handle_widget: 4
    end
  end

  def widget_register(socket, widget) do
    widgets = socket.assigns[:widgets] || []
    socket |> assign(widgets: Keyword.merge(widgets, [widget]))
  end

  def widget_close_all(socket, opts \\ []) do
    {id, toggle} = opts[:except] || {nil, false}
    for {widget_id, module} <- socket.assigns.widgets do
      unless widget_id == id && toggle do
        send_update module, id: widget_id, type: :command, active: false
      end
    end
    socket
  end

  def widget_assign(socket, widget) do
    socket |> assign(%{widget[:id] => Keyword.put(widget, :__widget__, true)})
  end

  def widget_update(socket, id, updates) do
    unless socket.assigns[id],
      do: raise(%ArgumentError{message: "widget variable not found in socket assigns"})

    socket |> assign(%{id => Keyword.merge(socket.assigns[id], updates)})
  end
end
