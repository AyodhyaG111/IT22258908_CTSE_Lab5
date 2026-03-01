# Microservices Lab - IT22258908

A complete microservices system built with Spring Boot, Docker, and Docker Compose.

## 📖 Documentation

Start with the appropriate documentation for your needs:

1. **[README.md](README.md)** (This file) - Quick overview and API reference
2. **[INSTALLATION.md](INSTALLATION.md)** - Setup instructions and troubleshooting
3. **[ARCHITECTURE.md](ARCHITECTURE.md)** - System design and detailed service documentation
4. **[TESTING.md](TESTING.md)** - Complete testing guide with examples
5. **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Comprehensive completion report

## System Architecture

- **Item Service** (Port 8081): Manages product inventory
- **Order Service** (Port 8082): Manages customer orders
- **Payment Service** (Port 8083): Processes payments
- **API Gateway** (Port 8080): Routes all requests to appropriate services

## Quick Start

### Build with Docker Compose

```bash
# Build all services
docker-compose build

# Start all containers
docker-compose up

# In another terminal, test with curl or Postman
```

### Test Endpoints

**GET Items:**
```bash
curl http://localhost:8080/items
```

**POST Item:**
```bash
curl -X POST http://localhost:8080/items \
  -H "Content-Type: application/json" \
  -d '{"name": "Headphones"}'
```

**POST Order:**
```bash
curl -X POST http://localhost:8080/orders \
  -H "Content-Type: application/json" \
  -d '{"item": "Laptop", "quantity": 2, "customerId": "C001"}'
```

**POST Payment:**
```bash
curl -X POST http://localhost:8080/payments/process \
  -H "Content-Type: application/json" \
  -d '{"orderId": 1, "amount": 1299.99, "method": "CARD"}'
```

## API Endpoints Reference

All endpoints are routed through API Gateway on port 8080.

### Item Service (`/items`)
- `GET /items` - Get all items
- `POST /items` - Create item
- `GET /items/{id}` - Get item by ID

### Order Service (`/orders`)
- `GET /orders` - Get all orders
- `POST /orders` - Create order
- `GET /orders/{id}` - Get order by ID

### Payment Service (`/payments`)
- `GET /payments` - Get all payments
- `POST /payments/process` - Process payment
- `GET /payments/{id}` - Get payment by ID

## Project Structure

```
├── item-service/        (Spring Boot on port 8081)
├── order-service/       (Spring Boot on port 8082)
├── payment-service/     (Spring Boot on port 8083)
├── api-gateway/         (Spring Cloud Gateway on port 8080)
├── docker-compose.yml
└── Documentation files
```

## Technologies Used

- Spring Boot 3.1.5
- Spring Cloud Gateway
- Docker & Docker Compose
- Java 17
- Maven

## Student Information

- **Student ID:** IT22258908
- **Module:** Current Trends in Software Engineering (SE4010)
- **Year:** 2026 | Semester 1
- **University:** SLIIT - Department of Computer Science & Software Engineering

## Helper Commands

```bash
# View running containers
docker-compose ps

# View service logs
docker-compose logs -f

# Stop all services
docker-compose down

# Rebuild without cache
docker-compose build --no-cache

# Test with Postman
# Import: Microservices-Lab-Collection.postman_collection.json
```

## Next Steps

1. Clone: `git clone https://github.com/AyodhyaG111/IT22258908_CTSE_Lab5.git`
2. Setup: See [INSTALLATION.md](INSTALLATION.md)
3. Run: `docker-compose up`
4. Test: See [TESTING.md](TESTING.md)
5. Learn: See [ARCHITECTURE.md](ARCHITECTURE.md)

## Support

- Check [INSTALLATION.md](INSTALLATION.md) for common issues
- Review [TESTING.md](TESTING.md) for testing procedures
- See [ARCHITECTURE.md](ARCHITECTURE.md) for system design details