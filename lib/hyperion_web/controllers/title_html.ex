defmodule HyperionWeb.TitleHTML do
  use HyperionWeb, :html

  embed_templates "title_html/*"

  @doc """
  Renders a title form.

  The form is defined in the template at
  title_html/title_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def title_form(assigns)
end
