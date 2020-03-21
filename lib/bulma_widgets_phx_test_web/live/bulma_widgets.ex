defmodule BulmaWidgets do
  import Phoenix.LiveView
  require Logger

  @doc """
  Imports various helpers to handle widget activations and state management.

  Currently only one variable `:widgets` is set in the socket assigns. This variable maintains
  a list of widgets which allows both the library and end users interact with widgets.

  One usage of this to close all other widgets that have an `active` state such as drop down menus.
  This makes using the widgets feel more cohesive and reduces the work required to configured
  similar behavior with uncennected widgets.
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

  @doc """
  Helper function to register a widget in the LiveView's socket assigns under the `:widgets` variable.
  """
  def widget_register(socket, widget) do
    widgets = socket.assigns[:widgets] || []
    socket |> assign(widgets: Keyword.merge(widgets, [widget]))
  end

  @doc """
  Helper function to close all active widgets like dropdowns or other menus.

  An option can be provided to exlucde a single widget:

      iex> socket |> widget_close_all(except: {:widget_id, true || false})

  """
  def widget_close_all(socket, opts \\ []) do
    {id, toggle} = opts[:except] || {nil, false}

    for {widget_id, module} <- socket.assigns.widgets do
      unless widget_id == id && toggle do
        send_update(module, id: widget_id, type: :command, active: false)
      end
    end

    socket
  end
end
