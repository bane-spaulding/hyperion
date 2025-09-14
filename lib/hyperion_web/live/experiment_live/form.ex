defmodule HyperionWeb.ExperimentLive.Form do
  use HyperionWeb, :live_view

  require Logger

  alias Hyperion.Experiments
  alias Hyperion.Repo.Experiment
  alias Hyperion.Videos.Thumbnails

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage experiment records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="experiment-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:channel_id]} type="text" label="Channel" />
        <.input field={@form[:video_id]} type="text" label="Video" />
        <.input field={@form[:title]} type="text" label="Title" />
        <div class="flex items-center gap-2" style="margin-top: 15px;margin-bottom: 20px;">
         <.live_file_input upload={@uploads.thumbnail}
                         class="block w-full text-sm text-gray-500 dark:text-gray-400
                                file:mr-4 file:py-2 file:px-4
                                file:rounded-md file:border-0
                                file:text-sm file:font-semibold
                                file:bg-blue-50 file:text-blue-700
                                dark:file:bg-blue-900 dark:file:text-blue-300
                                hover:file:bg-blue-100 dark:hover:file:bg-blue-800"
          />
        </div>


        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Experiment</.button>
          <.button navigate={return_path(@return_to, @experiment)}>Cancel</.button>
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
     |> apply_action(socket.assigns.live_action, params)
     |> allow_upload(:thumbnail, accept: ~w(.jpg .jpeg .png), max_entries: 1)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    experiment = Experiments.get_experiment!(id)

    socket
    |> assign(:page_title, "Edit Experiment")
    |> assign(:experiment, experiment)
    |> assign(:form, to_form(Experiments.change_experiment(experiment)))
  end

  defp apply_action(socket, :new, _params) do
    experiment = %Experiment{}

    socket
    |> assign(:page_title, "New Experiment")
    |> assign(:experiment, experiment)
    |> assign(:form, to_form(Experiments.change_experiment(experiment)))
  end

  @impl true
  def handle_event("validate", %{"experiment" => experiment_params}, socket) do
    changeset = Experiments.change_experiment(socket.assigns.experiment, experiment_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"experiment" => experiment_params}, socket) do
    case process_uploads(socket, experiment_params) do
      params_with_file_id ->
        save_experiment(socket, socket.assigns.live_action, params_with_file_id)
      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp process_uploads(socket, experiment_params) do
    case Enum.at(socket.assigns.uploads.thumbnail.entries, 0) do
      nil ->
        {:ok, experiment_params}
      upload_entry ->
        Phoenix.LiveView.consume_uploaded_entry(socket, upload_entry, fn %{path: path} ->
          upload = %Plug.Upload{
            path: path,
            filename: upload_entry.client_name,
            content_type: upload_entry.client_type
          }

          case Thumbnails.insert_thumbnail(upload, experiment_params["video_id"], experiment_params["channel_id"]) do
            {:ok, thumbnail} ->
              Logger.debug("Successfully uploaded #{upload.filename} to DB")
              {:ok, Map.put(experiment_params, "thumbnail_id", thumbnail.id)}
            {:error, changeset} ->
              Logger.error("Failed to save #{upload.filename} to DB: #{inspect(changeset)}")
              {:error, changeset}
          end
        end)
    end
  end

  defp save_experiment(socket, :edit, params) do
    case Experiments.update_experiment(socket.assigns.experiment, params) do
      {:ok, experiment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Experiment updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, experiment))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_experiment(socket, :new, experiment_params) do
    case Experiments.create_experiment(experiment_params) do
      {:ok, experiment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Experiment created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, experiment))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _experiment), do: ~p"/experiments"
  defp return_path("show", experiment), do: ~p"/experiments/#{experiment}"
end
