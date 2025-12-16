#!/bin/bash

# Update system
sudo yum update -y

# Install Docker
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create docker-compose.yml
cat > /home/ec2-user/docker-compose.yml <<'EOF'
version: '3.8'

services:
  frontend:
    image: ${dockerhub_username}/visitor-counter-frontend:latest
    container_name: visitor-frontend
    ports:
      - "80:80"
    depends_on:
      - backend
    restart: unless-stopped
    networks:
      - visitor-network

  backend:
    image: ${dockerhub_username}/visitor-counter-backend:latest
    container_name: visitor-backend
    environment:
      - PORT=3000
      - NODE_ENV=production
    restart: unless-stopped
    networks:
      - visitor-network
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

networks:
  visitor-network:
    driver: bridge
EOF

# Change ownership
sudo chown ec2-user:ec2-user /home/ec2-user/docker-compose.yml

# Pull images and start containers
cd /home/ec2-user
sudo /usr/local/bin/docker-compose pull
sudo /usr/local/bin/docker-compose up -d

# Create a cron job to check and restart containers if needed
cat > /home/ec2-user/check_containers.sh <<'EOF'
#!/bin/bash
cd /home/ec2-user
if ! sudo /usr/local/bin/docker-compose ps | grep -q "Up"; then
    sudo /usr/local/bin/docker-compose down
    sudo /usr/local/bin/docker-compose pull
    sudo /usr/local/bin/docker-compose up -d
fi
EOF

chmod +x /home/ec2-user/check_containers.sh
echo "*/5 * * * * /home/ec2-user/check_containers.sh" | sudo crontab -

# Log setup completion
echo "Docker setup completed at $(date)" > /home/ec2-user/setup.log
