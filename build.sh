set -o errexit

if ! command -v yt-dlp &> /dev/null; then
  echo "Installing yt-dlp..."
  sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
  sudo chmod a+rx /usr/local/bin/yt-dlp
fi

if ! command -v streamlink &> /dev/null; then
  echo "Installing streamlink..."
  sudo apt-get update
  sudo apt-get install -y streamlink
fi

mix clean
rm -rf _build
mix deps.get --only prod
MIX_ENV=prod mix compile

MIX_ENV=prod mix assets.build
MIX_ENV=prod mix assets.deploy

MIX_ENV=prod mix phx.gen.release
MIX_ENV=prod mix release --overwrite
