defmodule SafeBikeRoutesWeb.PageController do
  use SafeBikeRoutesWeb, :controller

  def home(conn, _params) do
    # redirect for now
    redirect(conn, to: ~p"/la")
  end
end
