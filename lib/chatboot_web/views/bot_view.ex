defmodule ChatbootWeb.BotView do
  use ChatbootWeb, :view

  def render("webhook.json", %{challenge: challenge}) do
    challenge
  end
end
