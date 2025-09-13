defmodule HyperionWeb.ExperimentHTML do
  use HyperionWeb, :html

  embed_templates "experiment_html/*"

  @doc """
  Renders a experiment form.

  The form is defined in the template at
  experiment_html/experiment_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def experiment_form(assigns)
end
