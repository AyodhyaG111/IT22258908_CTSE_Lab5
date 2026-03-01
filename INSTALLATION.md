# Installation & Setup Guide

## System Requirements

- **Docker Desktop**: [Download](https://www.docker.com/products/docker-desktop)
- **Docker Compose**: Included with Docker Desktop
- **Postman**: [Download](https://www.postman.com/downloads/)
- **Git**: [Download](https://git-scm.com/download)
- **Optional - Maven & Java 17**: For local development

### Minimum Hardware

- 4GB RAM (8GB recommended for smooth operation)
- 5GB free disk space
- Windows 10+, macOS, or Linux with Docker support

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/AyodhyaG111/IT22258908_CTSE_Lab5.git
cd IT22258908_CTSE_Lab5
```

### 2. Install Docker & Docker Compose

#### Windows/Mac
- Download Docker Desktop from https://www.docker.com/products/docker-desktop
- Run the installer
- Launch Docker Desktop
- Verify installation:
  ```bash
  docker --version
  docker-compose --version
  ```

#### Linux (Ubuntu/Debian)
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify
docker --version
docker-compose --version
```

### 3. Build the Microservices

#### Option A: Using Docker Compose (Recommended)

```bash
# Navigate to project directory
cd IT22258908_CTSE_Lab5

# Build all services
docker-compose build

# This will:
# - Pull the Java 17 Alpine image
# - Copy source code to build container
# - Download Maven dependencies
# - Compile Java code
# - Create JAR files
# - Create runtime Docker images
```

#### Option B: Using Build Script (Windows)

```batch
cd IT22258908_CTSE_Lab5
run.bat build
```

#### Option C: Using Build Script (Linux/Mac)

```bash
cd IT22258908_CTSE_Lab5
chmod +x run.sh
./run.sh build
```

### 4. Start the Services

#### Option A: Docker Compose

```bash
# Start all services
docker-compose up

# Or start in background
docker-compose up -d

# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f item-service
```

#### Option B: Using Run Script (Windows)

```batch
run.bat up
```

#### Option C: Using Run Script (Linux/Mac)

```bash
./run.sh up
```

### 5. Verify Services are Running

```bash
# Check all containers are running
docker ps

# Expected output should show:
# - api-gateway (port 8080)
# - item-service (port 8081)
# - order-service (port 8082)
# - payment-service (port 8083)
```

## Testing the Services

### Quick Test with curl (Command Line)

#### Get all items:
```bash
curl http://localhost:8080/items
```

#### Create a new item:
```bash
curl -X POST http://localhost:8080/items \
  -H "Content-Type: application/json" \
  -d '{"name": "Tablet"}'
```

#### Get all orders:
```bash
curl http://localhost:8080/orders
```

#### Create an order:
```bash
curl -X POST http://localhost:8080/orders \
  -H "Content-Type: application/json" \
  -d '{"item": "Laptop", "quantity": 2, "customerId": "C001"}'
```

#### Process a payment:
```bash
curl -X POST http://localhost:8080/payments/process \
  -H "Content-Type: application/json" \
  -d '{"orderId": 1, "amount": 1299.99, "method": "CARD"}'
```

### Test with Postman

1. **Import Collection:**
   - Open Postman
   - Click "File" → "Import"
   - Select `Microservices-Lab-Collection.postman_collection.json`
   - Click "Import"

2. **Run Requests:**
   - Expand "Microservices Lab - IT22258908" collection
   - Test each endpoint by clicking "Send"
   - Verify responses

3. **Expected Results:**
   - GET requests should return JSON arrays/objects
   - POST requests should return 201 Created status
   - All responses should include auto-generated IDs

### Web Browser Testing

Visit these URLs in your browser:

- Items: http://localhost:8080/items
- Orders: http://localhost:8080/orders
- Payments: http://localhost:8080/payments

## Stopping Services

### Using Docker Compose

```bash
# Stop containers (keep data)
docker-compose stop

# Stop and remove containers
docker-compose down

# Stop, remove, and delete volumes
docker-compose down -v
```

### Using Run Script

```bash
# Windows
run.bat down

# Linux/Mac
./run.sh down
```

## Troubleshooting

### Problem: Docker not found

**Solution:**
- Verify Docker is installed: `docker --version`
- Ensure Docker Desktop is running (on Windows/Mac)
- On Linux, may need to add user to docker group: `sudo usermod -aG docker $USER`

### Problem: Port 8080 already in use

**Solution:**
```bash
# Find process using port 8080
# Windows
netstat -ano | findstr :8080

# Linux/Mac
lsof -i :8080

# Kill the process (get PID from above)
# Windows
taskkill /PID <PID> /F

# Linux/Mac
kill -9 <PID>

# Or change port in docker-compose.yml
```

### Problem: Build fails downloading dependencies

**Solution:**
- Check internet connection
- Ensure Maven central repository is accessible
- Try building with: `docker-compose build --no-cache`

### Problem: Container exits immediately

**Solution:**
```bash
# Check logs
docker-compose logs item-service

# Rebuild
docker-compose build --no-cache

# Start with verbose logging
docker-compose up --no-log-prefix
```

### Problem: Cannot reach services on localhost

**Solution:**
- Verify containers are running: `docker ps`
- If using Docker Toolbox, replace localhost with: `192.168.99.100`
- If using WSL2 on Windows, use IP address of WSL2 VM

## Advanced Usage

### Rebuild and Restart Everything

```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### View Service Details

```bash
# Get container IP addresses
docker network inspect microservices-net

# Access container shell
docker exec -it item-service sh

# View container resource usage
docker stats
```

### Monitor Service Health

```bash
# Continuous logs
docker-compose logs -f --tail=50

# Specific service
docker-compose logs -f payment-service
```

## Development Notes

- Default data is stored in-memory (lost on restart)
- For persistent storage, add a database service to docker-compose.yml
- Modify source code in service directories and rebuild: `docker-compose build --no-cache`
- Each service runs independently on its own port

## Support

For issues or questions:
- Check logs: `docker-compose logs`
- Review README.md for API documentation
- Verify Docker is running properly
- Ensure ports 8080-8083 are available

## Next Steps

1. ✅ Clone repository
2. ✅ Install Docker
3. ✅ Run `docker-compose build`
4. ✅ Run `docker-compose up`
5. ✅ Test endpoints with Postman
6. ✅ Review service source code
7. ✅ Customize as needed

Happy testing! 🚀
