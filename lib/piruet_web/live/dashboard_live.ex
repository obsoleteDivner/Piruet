defmodule PiruetWeb.DashboardLive do
  use PiruetWeb, :live_view
  alias Piruet.OAuth, as: POAUTH
  alias Nostrum.Voice

  def render(assigns) do
    ~H"""
    <div>
      <%= if @auth_url do %>
        <a href={@auth_url}>
          <button>Авторизуватись через Discord</button>
        </a>
      <% end %>

      <form phx-submit="add_track">
        <input name="url" type="text" value={@url} placeholder="Введіть URL треку"/>
        <button type="submit">Додати в чергу</button>
      </form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    state = :crypto.strong_rand_bytes(16) |> Base.url_encode64()
    client = POAUTH.client() 
    auth_url = POAUTH.authorize_url(client, state)

    if connected?(socket), do: Phoenix.PubSub.subscribe(Piruet.PubSub, "tracks")
    {:ok, assign(socket, url: "", auth_url: auth_url)}
  end

  def handle_event("add_track", %{"url" => url}, socket) do
    # user_id = 599305172501528590
    guild_id = 819656355396059206
    channel_id = 875801015838998528

    Voice.join_channel(guild_id, channel_id) |> IO.inspect()
    try_play(guild_id, url, :ytdl)
    {:noreply, assign(socket, url: "")}
  end

  def try_play(guild_id, url, type, opts \\ []) do
    case Nostrum.Voice.play(guild_id, url, type, opts) do
      {:error, msg} ->
        IO.inspect(msg)
        Process.sleep(100)
        try_play(guild_id, url, type, opts)

      _ ->
        :ok
    end
  end
end
