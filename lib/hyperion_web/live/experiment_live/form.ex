defmodule HyperionWeb.ExperimentLive.Form do
  use HyperionWeb, :live_view

  require Logger

  alias Hyperion.Experiments
  alias Hyperion.Repo.Experiment
  alias Hyperion.Videos.Thumbnails

  @thumbnail_max_size_in_bytes 2_000_000

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
        <.input field={@form[:category_id]} type="number" label="CategoryId" />
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
     |> allow_upload(:thumbnail, accept: ~w(.jpg .jpeg .png), max_entries: 1, max_file_size: @thumbnail_max_size_in_bytes)}
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

    @impl true
  def handle_event("save", %{"experiment" => params}, socket) do
    thumbnail_attrs = case Enum.at(socket.assigns.uploads.thumbnail.entries, 0) do
      nil ->
        {:error, :no_upload}

      entry ->
        Phoenix.LiveView.consume_uploaded_entry(socket, entry, fn %{path: path} ->
        upload = %Plug.Upload{
          path: path,
          filename: entry.client_name,
          content_type: entry.client_type
        }

        {:ok,
         %{
           file_id: upload.filename,
           data: File.read!(upload.path),
           content_type: upload.content_type
         }}
      end)
    end

    case socket.assigns.live_action do
      :new ->
        case Experiments.create_experiment_with_thumbnail(params, thumbnail_attrs) do
          {:ok, %{experiment: experiment, thumbnail: _thumbnail}} ->
            {:noreply,
             socket
             |> put_flash(:info, "Experiment created successfully")
             |> push_navigate(to: return_path(socket.assigns.return_to, experiment))}

          {:error, _step, %Ecto.Changeset{} = changeset, _changes_so_far} ->
            {:noreply, assign(socket, form: to_form(changeset))}

          {:error, step, reason, _changes_so_far} ->
            Logger.error("Failed at step #{inspect(step)}: #{inspect(reason)}")
            {:noreply, socket |> put_flash(:error, "Failed to save experiment")}
        end
      :edit ->
        case thumbnail_attrs do
          {error, :no_upload} ->
            case Experiments.update_experiment(socket.assigns.experiment, params) do
              {:ok, experiment} ->
                {:noreply,
                 socket
                 |> put_flash(:info, "Experiment updated successfully.")
                 |> push_navigate(to: return_path(socket.assigns.return_to, experiment))}
              {:error, changeset} ->
                {:noreply, assign(socket, form: to_form(changeset))}
            end
          thumbnail_attrs ->
            case Experiments.update_experiment_with_thumbnail(socket.assigns.experiment, params, thumbnail_attrs) do
              {:ok, %{experiment: experiment}} ->
                {:noreply,
                 socket
                 |> put_flash(:info, "Experiment updated successfully with new thumbnail.")
                 |> push_navigate(to: return_path(socket.assigns.return_to, experiment))}
              {:error, _step, %Ecto.Changeset{} = changeset, _changes_so_far} ->
                {:noreply, assign(socket, form: to_form(changeset))}
              {:error, step, reason, _changes_so_far} ->
                Logger.error("Failed to update experiment with thumbnail at step #{inspect(step)}: #{inspect(reason)}")
                {:noreply, socket |> put_flash(:error, "Failed to update experiment with new thumbnail.")}
            end
        end
    end
  end

  defp consume_thumbnail_upload(socket) do
    case Enum.at(socket.assigns.uploads.thumbnail.entries, 0) do
      nil ->
        {:error, :no_upload}
      entry ->
        Phoenix.LiveView.consume_uploaded_entry(socket, entry, fn %{path: path} ->
          upload = %Plug.Upload{
            path: path,
            filename: entry.client_name,
            content_type: entry.client_type
          }
          {:ok, %{
            file_id: upload.filename,
            data: File.read!(upload.path),
            content_type: upload.content_type
          }}
        end)
    end
  end

  defp return_path("index", _experiment), do: ~p"/experiments"
  defp return_path("show", experiment), do: ~p"/experiments/#{experiment}"
end
