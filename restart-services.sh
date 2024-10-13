# /bin/bash
# Restart services
echo "Stopping tailscale"
sudo tailscale down --accept-risk=lose-ssh
tailscale status
echo "Stopping docker services"
docker compose down
docker network prune -f
echo "Waiting 2 seconds for networks to be released"
sleep 2
echo "Restarting docker services"
docker compose up -d
echo "Starting tailscale"
sudo tailscale up
tailscale status