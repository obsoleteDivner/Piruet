defmodule PiruetWeb.AuthController do
    use PiruetWeb, :controller
  
    alias Piruet.OAuth
  
    def callback(conn, %{"code" => code, "state" => _state}) do
      client = OAuth.client()
  
      with {:ok, %OAuth2.Client{token: %{access_token: access_token_coded}} = full_client} <- OAuth.exchange_code_for_token(client, code),
           {:ok, %{"access_token" => access_token}} <- JSON.decode(access_token_coded),
           {:ok, user_info} <- fetch_user_info(access_token) |> IO.inspect(label: "info")do
        # Можна зберегти user_info в сесії або БД
        conn
        |> put_session(:discord_user, user_info)
        |> put_session(:access_token, access_token)
        |> redirect(to: "/")
      else
        error ->
            IO.inspect(error, label: "ERORR")
          conn
          |> put_flash(:error, "Не вдалося авторизуватись через Discord.")
          |> redirect(to: "/")
      end
    end
  
    def callback(conn, _params) do
      conn
      |> put_flash(:error, "Авторизація неуспішна.")
      |> redirect(to: "/")
    end
  
    defp fetch_user_info(access_token) do
      headers = [
        {"Authorization", "Bearer #{access_token}"},
        {"Content-Type", "application/json"}
      ]
  
      url = "https://discord.com/api/users/@me"
  
      case Finch.build(:get, url, headers)
           |> Finch.request(Piruet.Finch) do
        {:ok, %Finch.Response{status: 200, body: body}} ->
          case Jason.decode(body) do
            {:ok, data} -> {:ok, data}
            _ -> {:error, :decode_failed}
          end
  
        _ -> {:error, :failed_request}
      end
    end
  end
  