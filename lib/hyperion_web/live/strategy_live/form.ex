defmodule HyperionWeb.StrategyLive.Form do
  use HyperionWeb, :live_view

  alias Hyperion.Strategies
  alias Hyperion.Repo.Strategy

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage strategy records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="strategy-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:status]} type="text" label="Status" />
        <.input field={@form[:start_ts]} type="datetime-local" label="Start ts" />
        <.input field={@form[:end_ts]} type="datetime-local" label="End ts" />
        <.input field={@form[:schedule]} type="text" label="Schedule" />
        <.input field={@form[:status]} type="select" label="Status" options={@status_options} />

        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Strategy</.button>
          <.button navigate={return_path(@return_to, @strategy)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(:status_options, Strategy.status_values())
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    strategy = Strategies.get_strategy!(id)

    socket
    |> assign(:page_title, "Edit Strategy")
    |> assign(:strategy, strategy)
    |> assign(:form, to_form(Strategies.change_strategy(strategy)))
  end

  defp apply_action(socket, :new, _params) do
    strategy = %Strategy{}

    socket
    |> assign(:page_title, "New Strategy")
    |> assign(:strategy, strategy)
    |> assign(:form, to_form(Strategies.change_strategy(strategy)))
  end

  @impl true
  def handle_event("validate", %{"strategy" => strategy_params}, socket) do
    changeset = Strategies.change_strategy(socket.assigns.strategy, strategy_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"strategy" => strategy_params}, socket) do
    save_strategy(socket, socket.assigns.live_action, strategy_params)
  end

  defp save_strategy(socket, :edit, strategy_params) do
    case Strategies.update_strategy(socket.assigns.strategy, strategy_params) do
      {:ok, strategy} ->
        {:noreply,
         socket
         |> put_flash(:info, "Strategy updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, strategy))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_strategy(socket, :new, strategy_params) do
    case Strategies.create_strategy(strategy_params) do
      {:ok, strategy} ->
        {:noreply,
         socket
         |> put_flash(:info, "Strategy created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, strategy))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _strategy), do: ~p"/strategies"
  defp return_path("show", strategy), do: ~p"/strategies/#{strategy}"
end
