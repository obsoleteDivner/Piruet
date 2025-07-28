defmodule PiruetWeb.DashboardLive do
    use PiruetWeb, :live_view
    alias Piruet.Music
    alias Piruet.Music.Track
    alias Nostrum.Voice

    def render(assigns) do
        ~H"""
        <div>
          <form phx-submit="add_track">
            <input name="url" type="text" value={@url} placeholder="Введіть URL треку"/>
            <button type="submit">Додати в чергу</button>
          </form>
      
          <ul>
            <%= for track <- @tracks do %>
              <li id={"track-#{track.id}"}>
                <%= track.url %> — <%= track.status %>
              </li>
            <% end %>
          </ul>
        </div>
        """
      end

      
    def mount(_params, _session, socket) do
      if connected?(socket), do: Phoenix.PubSub.subscribe(Piruet.PubSub, "tracks")
      tracks = Music.list_track()
      {:ok, assign(socket, tracks: tracks, url: "")}
    end
  

    def handle_event("add_track", %{"url" => url}, socket) do
        user_id = 599305172501528590
        guild_id = 819656355396059206
        channel_id = 875801015838998528

        Voice.join_channel(guild_id, channel_id) |> IO.inspect()
        # Voice.play(guild_id, url, :ytdl) |>IO.inspect(label: "Output")
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
      def handle_info({:new_track, track}, socket) do
        {:noreply, update(socket, :tracks, fn ts -> ts ++ [track] end)}
      end
    end
    