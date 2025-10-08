#!/bin/bash
# Safe deployment script for Al-Baqi Academy
# This script deploys code changes while preserving database and existing content

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Al-Baqi Academy - Safe Deployment ===${NC}\n"

# Configuration - UPDATE THESE VALUES BEFORE RUNNING
# IMPORTANT: Replace these placeholder values with your actual VPS details
VPS_USER="your_username"        # Example: "ubuntu" or "root"
VPS_HOST="your_vps_ip"          # Example: "123.456.789.0" or "albaqiacademy.com"
VPS_PATH="/path/to/web1"        # Example: "/home/ubuntu/web1" or "/var/www/web1"
APP_NAME="web1"                 # Your systemd service name (if using systemd)

# Validation - check if configuration is complete
if [ "$VPS_USER" = "your_username" ] || [ "$VPS_HOST" = "your_vps_ip" ]; then
    echo -e "${RED}ERROR: Please configure VPS details in this script before running!${NC}"
    echo "Edit the Configuration section at the top of this script."
    exit 1
fi

echo -e "${YELLOW}⚠️  IMPORTANT: This script will:${NC}"
echo "   ✓ Push code changes to VPS"
echo "   ✓ Preserve all database data"
echo "   ✓ Preserve existing course files"
echo "   ✓ Run database migrations safely"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Deployment cancelled."
    exit 1
fi

echo -e "\n${GREEN}Step 1: Committing local changes${NC}"
git add .
git status
read -p "Create commit? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Commit message: " commit_msg
    git commit -m "$commit_msg"
else
    echo "Skipping commit..."
fi

echo -e "\n${GREEN}Step 2: Pushing to repository${NC}"
git push origin main

echo -e "\n${GREEN}Step 3: Deploying to VPS${NC}"
ssh $VPS_USER@$VPS_HOST << 'ENDSSH'
set -e
cd $VPS_PATH

echo "→ Backing up current code..."
cp -r . ../web1_backup_$(date +%Y%m%d_%H%M%S) || true

echo "→ Pulling latest changes..."
git pull origin main

echo "→ Activating virtual environment..."
source venv/bin/activate

echo "→ Installing/updating dependencies..."
pip install -r requirements.txt

echo "→ Running database migrations..."
flask db upgrade

echo "→ Restarting application..."
if command -v systemctl &> /dev/null; then
    sudo systemctl restart $APP_NAME || echo "Could not restart service. Please restart manually."
else
    echo "Please restart your application manually (e.g., supervisorctl restart $APP_NAME)"
fi

echo "✓ Deployment complete!"
ENDSSH

echo -e "\n${GREEN}✓ Deployment successful!${NC}"
echo -e "${YELLOW}Note: New course files must be uploaded separately (see upload_courses.sh)${NC}"
