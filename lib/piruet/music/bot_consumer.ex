defmodule Piruet.BotConsumer do
    use Nostrum.Consumer
    alias Nostrum.Api
    alias Piruet.Music.Queue
  
    # Запуск споживача
    def start_link do
      Nostrum.Consumer.start_link(__MODULE__)
    end
  
    # Обробляємо події від Discord
    def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
      case String.split(msg.content) do
        ["!join"]      -> join_voice(msg)
        ["!play", url] -> PlayerQueue.enqueue({:play, url})
        ["!pause"]     -> PlayerQueue.enqueue(:pause)
        ["!skip"]      -> PlayerQueue.enqueue(:skip)
        _              -> :noop
      end
  
      {:ok}
    end
  
    # Приклад підключення до голосового каналу
    defp join_voice(msg) do
      channel_id = get_in(msg.author.voice_state, [:channel_id])
      case Nostrum.Voice.connect(msg.guild_id, channel_id) do
        {:ok, _vc} -> Api.create_message(msg.channel_id, "Підключено до голосового каналу!")
        {:error, reason} -> Api.create_message(msg.channel_id, "Помилка: #{inspect(reason)}")
      end
    end
  end
  