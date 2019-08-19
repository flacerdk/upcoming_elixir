defmodule UpcomingWeb.PageController do
  use UpcomingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
