defmodule Piruet.OAuth do
    alias OAuth2.Client
    alias OAuth2.Strategy.AuthCode
  
    @doc """
    Returns a configured OAuth2 client for Discord.
    """
    def client do
      Client.new(
        strategy: AuthCode,
        client_id: Application.get_env(:piruet, :client_id),
        client_secret: Application.get_env(:piruet, :client_secret),
        site: "https://discord.com",
        authorize_url: "https://discord.com/oauth2/authorize",
        token_url: "https://discord.com/api/oauth2/token",
        redirect_uri: Application.get_env(:piruet, :redirect_uri)
      )
    end
  
    @doc """
    Generates the Discord authorization URL.
    """
    def authorize_url(client, state) do
      Client.authorize_url!(client,
        state: state,
         scope: "identify email guilds bot applications.commands"

      )
    end
  
    @doc """
    Exchanges the authorization code for an access token.
    """
    def exchange_code_for_token(client, code) do
      Client.get_token(client,
        code: code,
        client_secret: Application.get_env(:piruet, :client_secret)
      )
    end
  end
  