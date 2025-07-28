defmodule PiruetWeb.DashboardLive do
    use PiruetWeb, :live_view
    alias Piruet.Music
    alias Piruet.Music.Track

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
        {:ok, %Track{} = track} = Music.create_track(%{url: url, status: "tracked"})
        Phoenix.PubSub.broadcast(Piruet.PubSub, "tracks", {:new_track, track})
        {:noreply, assign(socket, url: "")}
      end
    
      def handle_info({:new_track, track}, socket) do
        {:noreply, update(socket, :tracks, fn ts -> ts ++ [track] end)}
      end
    end
    