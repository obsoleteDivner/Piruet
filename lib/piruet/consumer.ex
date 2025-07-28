defmodule Piruet.Consumer do
    @moduledoc """
    The main consumer module. This handles all of the events
    from nostrum and redirects them to the modules which use them.
    """
    alias Piruet.Consumers.VoiceEvent
    use Nostrum.Consumer
  
    def start_link do
      Consumer.start_link(__MODULE__)
    end

    def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
        IO.inspect(msg)
      
        if msg.content == "!ping" do
          Nostrum.Api.create_message(msg.channel_id, "Pong!")
        end
      
        :ok
      end

      def handle_event({:READY, _, _}) do
        Nostrum.Api.Self.update_status("", "music 🎶", 2) |> IO.inspect()
      end
    
      def handle_event({:VOICE_SERVER_UPDATE, data, _}) do
        state = %{
          guild_id: data.guild_id,
          token: data.token,
          endpoint: data.endpoint
        }
      
        # Очікуємо, що VOICE_STATE_UPDATE вже був або буде, тому просто кладемо кудись тимчасово
        Process.put(:voice_server_update, state)
      
        try_connect()
      end
      
      def handle_event({:VOICE_STATE_UPDATE, data, _}) do
        state = %{
          guild_id: data.guild_id,
          session_id: data.session_id,
          user_id: data.user_id
        }
      
        Process.put(:voice_state_update, state)
      
        try_connect()
      end
    
defp try_connect do
    case {
      Process.get(:voice_server_update),
      Process.get(:voice_state_update)
    } do
      {%{guild_id: guild_id, token: token, endpoint: endpoint},
       %{session_id: session_id, user_id: _user_id}} ->
        {:ok, voice_pid} =
          Nostrum.Voice.connect(
            guild_id,
            session_id,
            token,
            endpoint
          )
  
        # play mp3 або dca файл (тільки mono 48kHz!)
        Nostrum.Voice.play(voice_pid, "priv/audio/sample.dca")
  
        :ok
  
      _ ->
        :noop
    end
    end
    def try_play(guild_id, url, type, opts \\ []) do
        case Nostrum.Voice.play(guild_id, url, type, opts) do
          {:error, _msg} ->
            Process.sleep(100)
            try_play(guild_id, url, type, opts)
      
          _ ->
            :ok
        end
      end

      def connect(guild_id, token, endpoint) do
        Logger.info("Connecting to voice server for guild #{guild_id}")
        Logger.debug("Voice token: #{token}")
        Logger.debug("Voice endpoint: #{endpoint}")
    
        # Тут у майбутньому реалізуєш voice WebSocket handshake (IDENTIFY і т.д.)
        :ok
      end
  end