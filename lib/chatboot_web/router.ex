defmodule ChatbootWeb.Router do
  use ChatbootWeb, :router
  use FacebookMessenger.Phoenix.Router

  # facebook_routes("/api/webhook", ChatbootWeb.BotController)

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :bot do
    plug(:accepts, ["json"])
  end

  scope "/bot", ChatbootWeb do
    pipe_through(:bot)

    get("/webhook", BotController, :webhook)
    post("/webhook", BotController, :message)
  end

  scope "/", ChatbootWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChatbootWeb do
  #   pipe_through :api
  # end
end
