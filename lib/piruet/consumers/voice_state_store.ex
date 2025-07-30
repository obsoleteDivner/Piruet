defmodule Piruet.VoiceStateStore do
    use Agent
  
    def start_link(_opts) do
      Agent.start_link(fn -> %{} end, name: __MODULE__)
    end
  
    def store_voice_state(guild_id, session_id) do
      Agent.update(__MODULE__, fn state ->
        Map.update(state, guild_id, %{session_id: session_id}, fn data ->
          Map.put(data, :session_id, session_id)
        end)
      end)
    end
  
    def store_voice_server(guild_id, token, endpoint) do
      Agent.update(__MODULE__, fn state ->
        Map.update(state, guild_id, %{token: token, endpoint: endpoint}, fn data ->
          data
          |> Map.put(:token, token)
          |> Map.put(:endpoint, endpoint)
        end)
      end)
    end
  
    def get_voice_data(guild_id) do
      Agent.get(__MODULE__, fn state -> Map.get(state, guild_id) end)
    end
  end
  