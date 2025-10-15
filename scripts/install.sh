# Install Homebrew if not installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Docker Desktop using Homebrew Cask
brew install --cask docker

# Start Docker Desktop from Applications
open /Applications/Docker.app

# Verify installation
docker --version
docker compose version

