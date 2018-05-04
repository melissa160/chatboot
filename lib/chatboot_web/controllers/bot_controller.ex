defmodule ChatbootWeb.BotController do
  use ChatbootWeb, :controller

  def webhook(conn, %{"hub.challenge" => challenge}) do
    challenge =
      challenge
      |> String.to_integer()

    render(conn, "webhook.json", challenge: challenge)
  end

  def message(conn, %{
        "entry" => [
          %{
            "messaging" => [
              %{"message" => %{"text" => message}, "sender" => %{"id" => sender_id}}
            ]
          }
        ]
      }) do
    ChatbootWeb.Bot.whitelist_urls()
    ChatbootWeb.Bot.respond_to_message(message, sender_id)

    conn
    |> send_resp(200, "ok")
  end
end
