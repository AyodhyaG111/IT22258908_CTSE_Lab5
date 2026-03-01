# System Architecture

## Overview

This microservices system demonstrates a polyglot architecture with independent, containerized services communicating through an API Gateway. Each service is self-contained, independently deployable, and uses Spring Boot REST APIs.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER                          │
│  (Postman / Browser / Mobile App / Web Frontend)             │
└────────────────────────┬────────────────────────────────────┘
                         │ HTTP/REST
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   API GATEWAY (Port 8080)                   │
│              Spring Cloud Gateway                            │
│         Routes requests to appropriate services              │
│     /items/** → Item Service                                │
│     /orders/** → Order Service                              │
│     /payments/** → Payment Service                          │
└────────────┬──────────────────┬─────────────────────┬────────┘
             │                  │                     │
             ▼                  ▼                     ▼
    ┌──────────────────┐  ┌─────────────────┐  ┌──────────────────┐
    │ ITEM SERVICE     │  │ ORDER SERVICE   │  │ PAYMENT SERVICE  │
    │ Port: 8081       │  │ Port: 8082      │  │ Port: 8083       │
    │ Spring Boot      │  │ Spring Boot     │  │ Spring Boot      │
    │ ────────────     │  │ ─────────────   │  │ ───────────────  │
    │ GET /items       │  │ GET /orders     │  │ GET /payments    │
    │ POST /items      │  │ POST /orders    │  │ POST /payments   │
    │ GET /items/{id}  │  │ GET /orders/{id}│  │ GET /payments/{id}
    │                  │  │                 │  │                  │
    │ In-Memory Data:  │  │ In-Memory Data: │  │ In-Memory Data:  │
    │ - Book           │  │ - Pending       │  │ - SUCCESS        │
    │ - Laptop         │  │ - Orders list   │  │ - Payments list  │
    │ - Phone          │  │ - ID Counter    │  │ - ID Counter     │
    └──────────────────┘  └─────────────────┘  └──────────────────┘
             │                  │                     │
             │   Docker Network: microservices-net   │
             └──────────────────┬────────────────────┘
                                │
                    ┌───────────────────────┐
                    │   Docker Bridge      │
                    │   Network Driver     │
                    └───────────────────────┘
```

## Service Details

### 1. Item Service (Port 8081)

**Responsibility:** Manage product inventory

**Endpoints:**
- `GET /items` - Retrieve all items
- `POST /items` - Add new item
- `GET /items/{id}` - Get specific item

**Data Model:**
```json
{
  "id": 1,
  "name": "Book"
}
```

**Technology Stack:**
- Framework: Spring Boot 3.1.5
- Language: Java 17
- Build Tool: Maven

**Sample Requests:**
```bash
# Get all items
curl GET http://localhost:8080/items

# Create new item
curl -X POST http://localhost:8080/items \
  -H "Content-Type: application/json" \
  -d '{"name": "Tablet"}'

# Get item with ID 1
curl GET http://localhost:8080/items/1
```

### 2. Order Service (Port 8082)

**Responsibility:** Process and track customer orders

**Endpoints:**
- `GET /orders` - Retrieve all orders
- `POST /orders` - Place new order
- `GET /orders/{id}` - Get specific order

**Data Model:**
```json
{
  "id": 1,
  "item": "Laptop",
  "quantity": 2,
  "customerId": "C001",
  "status": "PENDING"
}
```

**Technology Stack:**
- Framework: Spring Boot 3.1.5
- Language: Java 17
- Build Tool: Maven

**Sample Requests:**
```bash
# Get all orders
curl GET http://localhost:8080/orders

# Create new order
curl -X POST http://localhost:8080/orders \
  -H "Content-Type: application/json" \
  -d '{
    "item": "Laptop",
    "quantity": 2,
    "customerId": "C001"
  }'

# Get order with ID 1
curl GET http://localhost:8080/orders/1
```

### 3. Payment Service (Port 8083)

**Responsibility:** Process payment transactions

**Endpoints:**
- `GET /payments` - Retrieve all payments
- `POST /payments/process` - Process new payment
- `GET /payments/{id}` - Get payment status

**Data Model:**
```json
{
  "id": 1,
  "orderId": 1,
  "amount": 1299.99,
  "method": "CARD",
  "status": "SUCCESS"
}
```

**Technology Stack:**
- Framework: Spring Boot 3.1.5
- Language: Java 17
- Build Tool: Maven

**Sample Requests:**
```bash
# Get all payments
curl GET http://localhost:8080/payments

# Process payment
curl -X POST http://localhost:8080/payments/process \
  -H "Content-Type: application/json" \
  -d '{
    "orderId": 1,
    "amount": 1299.99,
    "method": "CARD"
  }'

# Get payment with ID 1
curl GET http://localhost:8080/payments/1
```

### 4. API Gateway (Port 8080)

**Responsibility:** Central routing and access point for all services

**Routing Rules:**
- `/items/**` → Item Service (8081)
- `/orders/**` → Order Service (8082)
- `/payments/**` → Payment Service (8083)

**Technology Stack:**
- Framework: Spring Cloud Gateway
- Language: Java 17
- Build Tool: Maven

**Features:**
- Request routing based on URL path
- Service discovery via Docker DNS
- Load balancing capability
- Request/response interception

**Configuration (application.yml):**
```yaml
server:
  port: 8080

spring:
  cloud:
    gateway:
      routes:
        - id: item-service
          uri: http://item-service:8081
          predicates:
            - Path=/items/**
```

## Data Flow Example

### Scenario: Create Order and Process Payment

1. **Client sends request to Gateway:**
   ```
   POST http://localhost:8080/orders
   {
     "item": "Laptop",
     "quantity": 1,
     "customerId": "C001"
   }
   ```

2. **Gateway routes to Order Service:**
   - Matches `/orders/**` route
   - Forwards to http://order-service:8082

3. **Order Service processes:**
   - Assigns ID: 1
   - Sets status: PENDING
   - Stores in memory
   - Returns response

4. **Client processes Payment:**
   ```
   POST http://localhost:8080/payments/process
   {
     "orderId": 1,
     "amount": 999.99,
     "method": "CARD"
   }
   ```

5. **Gateway routes to Payment Service:**
   - Matches `/payments/**` route
   - Forwards to http://payment-service:8083

6. **Payment Service processes:**
   - Accepts payment
   - Sets status: SUCCESS
   - Stores in memory
   - Returns response with ID

## Docker Networking

### Network Configuration

**Network Name:** `microservices-net`
**Driver:** Bridge

**Container Hostnames:**
- `item-service` - Item Service internal hostname
- `order-service` - Order Service internal hostname
- `payment-service` - Payment Service internal hostname
- `api-gateway` - API Gateway internal hostname

**Port Mapping:**
```
Docker Network         →  Host Machine
8081/item-service     →  localhost:8081
8082/order-service    →  localhost:8082
8083/payment-service  →  localhost:8083
8080/api-gateway      →  localhost:8080
```

### Service-to-Service Communication

Within Docker network, services communicate using:
- Container name as hostname (no need for localhost)
- Internal port numbers (8081, 8082, 8083)
- Example: `http://item-service:8081/items`

From host machine:
- Use `localhost` or `127.0.0.1`
- Use mapped ports
- Example: `http://localhost:8081/items`

## Deployment Architecture

### Build Process

```
Source Code
    ↓
Docker Build (Multi-stage)
    ├─ Stage 1: Build
    │   ├─ Install Maven
    │   ├─ Download dependencies
    │   ├─ Compile Java
    │   └─ Create JAR
    ├─ Stage 2: Runtime
    │   ├─ Copy JAR from build stage
    │   ├─ Install runtime deps
    │   └─ Configure entrypoint
    ↓
Docker Image
    ↓
Docker Container
    └─ Running Service
```

### Runtime Stack

```
Java Application
    ↓
Spring Boot
    ↓
Tomcat Embedded Server
    ↓
TCP Port
    ↓
Docker Port Mapping
    ↓
Host Network
```

## Scalability Considerations

### Current State
- Single instance of each service
- In-memory data storage
- No persistence layer

### Scaling Strategies

1. **Horizontal Scaling:**
   - Add multiple instances of each service
   - Use load balancer
   - Coordinate data sharing

2. **Data Persistence:**
   - Replace in-memory storage with database
   - Add PostgreSQL/MongoDB service
   - Update Dockerfiles and docker-compose.yml

3. **Advanced Patterns:**
   - Add message queue (RabbitMQ/Kafka)
   - Implement event-driven architecture
   - Add logging/monitoring (ELK stack)
   - Add distributed tracing (Jaeger)

## Security Considerations

### Current Implementation
- No authentication/authorization
- HTTP (not HTTPS)
- Internal Docker network only

### Production Hardening

1. **API Security:**
   - Add JWT token validation
   - Implement rate limiting
   - Add API versioning

2. **Network Security:**
   - Enable TLS/SSL encryption
   - Use HTTPS
   - Implement VPN/private networks

3. **Data Security:**
   - Add database encryption
   - Implement access controls
   - Add audit logging

## Performance Optimization

### Current State
- In-memory ArrayList storage
- Simple REST endpoints
- No caching

### Optimization Opportunities

1. **Caching:**
   - Add Redis cache layer
   - Implement local caching
   - Cache frequently accessed items

2. **Database Optimization:**
   - Add database indexes
   - Implement connection pooling
   - Optimize queries

3. **API Optimization:**
   - Implement pagination
   - Add response compression
   - Use database projections

## Monitoring & Logging

### Recommended Tools

1. **Logging:**
   - ELK Stack (Elasticsearch, Logstash, Kibana)
   - Splunk
   - Datadog

2. **Monitoring:**
   - Prometheus + Grafana
   - New Relic
   - Datadog

3. **Tracing:**
   - Jaeger
   - Zipkin
   - DataDog APM

## Technology Justification

| Service | Technology | Reason |
|---------|-----------|--------|
| Item, Order, Payment | Spring Boot | Proven enterprise framework, excellent for REST APIs |
| API Gateway | Spring Cloud Gateway | Native Spring Cloud support, flexible routing |
| Container Runtime | Docker | Industry standard, lightweight, fast |
| Orchestration | Docker Compose | Simple for local development, sufficient for lab |
| Build Tool | Maven | Java standard, dependency management |
| JDK | Eclipse Temurin 17 | Open source, lightweight Alpine version |

## Future Enhancements

1. Add Health Check endpoints
2. Implement circuit breaker pattern
3. Add database persistence layer
4. Implement authentication/authorization
5. Add API documentation (Swagger/OpenAPI)
6. Add comprehensive logging
7. Add distributed tracing
8. Implement message-driven architecture
9. Add containerized database services
10. Implement CI/CD pipeline
