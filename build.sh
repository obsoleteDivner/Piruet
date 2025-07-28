set -o errexit

if ! command -v yt-dlp &> /dev/null; then
  echo "Installing yt-dlp..."
  mkdir -p ~/.local/bin
  curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o ~/.local/bin/yt-dlp
  chmod a+rx ~/.local/bin/yt-dlp
  export PATH=$HOME/.local/bin:$PATH
fi

mix clean
rm -rf _build
mix deps.get --only prod
MIX_ENV=prod mix compile

MIX_ENV=prod mix assets.build
MIX_ENV=prod mix assets.deploy

MIX_ENV=prod mix phx.gen.release
MIX_ENV=prod mix release --overwrite
