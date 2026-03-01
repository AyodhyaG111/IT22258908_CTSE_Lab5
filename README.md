# Microservices Lab - IT22258908

A complete microservices system built with Spring Boot, Docker, and Docker Compose.

## System Architecture

- **Item Service** (Port 8081): Manages item inventory
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

# In another terminal, test with Postman or curl
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
└── README.md
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