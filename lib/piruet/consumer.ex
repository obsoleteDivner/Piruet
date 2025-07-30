defmodule Piruet.Consumer do
    @moduledoc """
    The main consumer module. This handles all of the events
    from nostrum and redirects them to the modules which use them.
    """
    use Nostrum.Consumer
  
      def handle_event({:READY, _, _}) do
        Nostrum.Api.Self.update_status("", "music 🎶", 2) |> IO.inspect()
      end
    
      def handle_event({:VOICE_SERVER_UPDATE, data, _}) do
        state = %{
          guild_id: data.guild_id,
          token: data.token,
          endpoint: data.endpoint
        }
      
        Process.put(:voice_server_update, state)
      

      end
      
      def handle_event({:VOICE_STATE_UPDATE, data, _}) do
        state = %{
          guild_id: data.guild_id,
          session_id: data.session_id,
          user_id: data.user_id
        }
      
        Process.put(:voice_state_update, state)

      end
    
  end