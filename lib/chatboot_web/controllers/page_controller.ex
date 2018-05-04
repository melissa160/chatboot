defmodule ChatbootWeb.PageController do
  use ChatbootWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
