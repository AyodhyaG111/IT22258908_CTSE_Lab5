# Testing Guide

## Overview

This document provides comprehensive testing procedures for the microservices system. All tests should be performed after services are running with `docker-compose up`.

## Prerequisites for Testing

1. Docker services running: `docker-compose up -d`
2. All containers should be in "Up" state: `docker ps`
3. API Gateway accessible at: `http://localhost:8080`
4. Postman installed (optional, curl works too)

## Testing Methods

### Method 1: Using curl (Command Line)

#### Test Item Service

**1. Get all items:**
```bash
curl http://localhost:8080/items
```

Expected Response (200 OK):
```json
[
  {
    "id": 1,
    "name": "Book"
  },
  {
    "id": 2,
    "name": "Laptop"
  },
  {
    "id": 3,
    "name": "Phone"
  }
]
```

**2. Get specific item:**
```bash
curl http://localhost:8080/items/1
```

Expected Response (200 OK):
```json
{
  "id": 1,
  "name": "Book"
}
```

**3. Create new item:**
```bash
curl -X POST http://localhost:8080/items \
  -H "Content-Type: application/json" \
  -d '{"name": "Tablet"}'
```

Expected Response (201 Created):
```json
{
  "id": 4,
  "name": "Tablet"
}
```

**4. Test invalid item ID:**
```bash
curl http://localhost:8080/items/999
```

Expected Response (404 Not Found):
```
(empty response body)
```

#### Test Order Service

**1. Get all orders (initially empty):**
```bash
curl http://localhost:8080/orders
```

Expected Response (200 OK):
```json
[]
```

**2. Create an order:**
```bash
curl -X POST http://localhost:8080/orders \
  -H "Content-Type: application/json" \
  -d '{
    "item": "Laptop",
    "quantity": 2,
    "customerId": "C001"
  }'
```

Expected Response (201 Created):
```json
{
  "item": "Laptop",
  "quantity": 2,
  "customerId": "C001",
  "id": 1,
  "status": "PENDING"
}
```

**3. Get all orders:**
```bash
curl http://localhost:8080/orders
```

Expected Response (200 OK):
```json
[
  {
    "item": "Laptop",
    "quantity": 2,
    "customerId": "C001",
    "id": 1,
    "status": "PENDING"
  }
]
```

**4. Get specific order:**
```bash
curl http://localhost:8080/orders/1
```

Expected Response (200 OK):
```json
{
  "item": "Laptop",
  "quantity": 2,
  "customerId": "C001",
  "id": 1,
  "status": "PENDING"
}
```

#### Test Payment Service

**1. Get all payments (initially empty):**
```bash
curl http://localhost:8080/payments
```

Expected Response (200 OK):
```json
[]
```

**2. Process a payment:**
```bash
curl -X POST http://localhost:8080/payments/process \
  -H "Content-Type: application/json" \
  -d '{
    "orderId": 1,
    "amount": 1299.99,
    "method": "CARD"
  }'
```

Expected Response (201 Created):
```json
{
  "orderId": 1,
  "amount": 1299.99,
  "method": "CARD",
  "id": 1,
  "status": "SUCCESS"
}
```

**3. Get all payments:**
```bash
curl http://localhost:8080/payments
```

Expected Response (200 OK):
```json
[
  {
    "orderId": 1,
    "amount": 1299.99,
    "method": "CARD",
    "id": 1,
    "status": "SUCCESS"
  }
]
```

**4. Get specific payment:**
```bash
curl http://localhost:8080/payments/1
```

Expected Response (200 OK):
```json
{
  "orderId": 1,
  "amount": 1299.99,
  "method": "CARD",
  "id": 1,
  "status": "SUCCESS"
}
```

### Method 2: Using Postman

#### Import Collection

1. Open Postman
2. Click "File" → "Import"
3. Select `Microservices-Lab-Collection.postman_collection.json`
4. Click "Import"

#### Run Requests

All requests are organized by service:

**Item Service:**
- GET All Items
- GET Item by ID
- POST Create Item

**Order Service:**
- GET All Orders
- GET Order by ID
- POST Create Order

**Payment Service:**
- GET All Payments
- GET Payment by ID
- POST Process Payment

#### Customizing Requests in Postman

1. Select a request
2. Modify the body (for POST requests)
3. Click "Send"
4. Check response status and body

### Method 3: Using Web Browser

Open these URLs in your browser:

1. **Items:** http://localhost:8080/items
2. **Orders:** http://localhost:8080/orders
3. **Payments:** http://localhost:8080/payments

*Note: Only GET requests work in browser. Use curl or Postman for POST requests.*

## Comprehensive Test Scenarios

### Scenario 1: Complete Order-to-Payment Flow

Test the entire workflow from items to payment:

```bash
#!/bin/bash

echo "=== Scenario: Complete Order-to-Payment Flow ==="

echo -e "\n1. Get available items"
curl -s http://localhost:8080/items | json_pp

echo -e "\n2. Create a new item"
curl -s -X POST http://localhost:8080/items \
  -H "Content-Type: application/json" \
  -d '{"name": "Headphones"}' | json_pp

echo -e "\n3. Create an order"
RESPONSE=$(curl -s -X POST http://localhost:8080/orders \
  -H "Content-Type: application/json" \
  -d '{
    "item": "Laptop",
    "quantity": 1,
    "customerId": "C002"
  }')
echo "$RESPONSE" | json_pp

echo -e "\n4. Process payment for the order"
curl -s -X POST http://localhost:8080/payments/process \
  -H "Content-Type: application/json" \
  -d '{
    "orderId": 1,
    "amount": 999.99,
    "method": "CARD"
  }' | json_pp

echo -e "\n5. Verify order created"
curl -s http://localhost:8080/orders | json_pp

echo -e "\n6. Verify payment processed"
curl -s http://localhost:8080/payments | json_pp

echo -e "\n=== Scenario Complete ==="
```

### Scenario 2: Multiple Orders and Payments

```bash
#!/bin/bash

echo "=== Scenario: Multiple Orders and Payments ==="

# Create multiple orders
for i in {1..3}; do
  echo -e "\nCreating order $i..."
  curl -s -X POST http://localhost:8080/orders \
    -H "Content-Type: application/json" \
    -d "{
      \"item\": \"Product $i\",
      \"quantity\": $i,
      \"customerId\": \"C$(printf '%03d' $i)\"
    }" | json_pp
done

# Process payments for orders
for i in {1..3}; do
  echo -e "\nProcessing payment for order $i..."
  curl -s -X POST http://localhost:8080/payments/process \
    -H "Content-Type: application/json" \
    -d "{
      \"orderId\": $i,
      \"amount\": $((100 * i)).99,
      \"method\": \"CARD\"
    }" | json_pp
done

echo -e "\n=== All Orders and Payments ==="
echo "Orders:"
curl -s http://localhost:8080/orders | json_pp
echo "Payments:"
curl -s http://localhost:8080/payments | json_pp
```

### Scenario 3: Error Handling

Test error cases:

```bash
#!/bin/bash

echo "=== Scenario: Error Handling ==="

echo -e "\n1. Request non-existent item (expects 404)"
curl -i http://localhost:8080/items/999

echo -e "\n2. Request non-existent order (expects 404)"
curl -i http://localhost:8080/orders/999

echo -e "\n3. Request non-existent payment (expects 404)"
curl -i http://localhost:8080/payments/999

echo -e "\n4. Invalid JSON payload (Service should handle gracefully)"
curl -i -X POST http://localhost:8080/items \
  -H "Content-Type: application/json" \
  -d 'invalid json'
```

## Expected HTTP Status Codes

| Method | Endpoint | Success Code | Description |
|--------|----------|--------------|-------------|
| GET | /items | 200 | Items retrieved successfully |
| GET | /items/{id} | 200 | Item found |
| GET | /items/{id} | 404 | Item not found |
| POST | /items | 201 | Item created |
| GET | /orders | 200 | Orders retrieved successfully |
| GET | /orders/{id} | 200 | Order found |
| GET | /orders/{id} | 404 | Order not found |
| POST | /orders | 201 | Order created |
| GET | /payments | 200 | Payments retrieved |
| GET | /payments/{id} | 200 | Payment found |
| GET | /payments/{id} | 404 | Payment not found |
| POST | /payments/process | 201 | Payment processed |

## Performance Testing

### Stress Test with Apache Bench

```bash
# Test Item Service GET endpoint (100 requests, 10 concurrent)
ab -n 100 -c 10 http://localhost:8080/items

# Test Order Service POST endpoint
ab -n 100 -c 10 -p payload.json -T application/json http://localhost:8080/orders
```

### Load Testing with wrk

```bash
# Install wrk: https://github.com/wg/wrk

# Test with 4 threads, 100 connections, 10s duration
wrk -t4 -c100 -d10s http://localhost:8080/items

# Test POST endpoint
wrk -t4 -c100 -d10s -s upload.lua http://localhost:8080/orders
```

## Logging and Debugging

### View Service Logs

```bash
# All services
docker-compose logs

# Specific service
docker-compose logs item-service

# Follow logs (tail)
docker-compose logs -f

# Last 50 lines
docker-compose logs --tail=50
```

### Access Service Shell

```bash
# Connect to container shell
docker exec -it item-service sh

# Run commands inside container
docker exec item-service ps aux

# Check configuration
docker exec item-service cat /app/application.yml
```

### Check Network Connectivity

```bash
# From host to container
curl http://localhost:8080/items

# From container to container (inside Item Service)
docker exec item-service curl http://order-service:8082/orders

# Check DNS resolution
docker exec item-service nslookup order-service
```

## Troubleshooting Tests

### Services Not Responding

```bash
# Check if containers are running
docker ps

# Expected output should show:
# item-service, order-service, payment-service, api-gateway
# All with status "Up"

# If not running, start them
docker-compose up -d
docker-compose logs  # check for errors
```

### Port Already in Use

```bash
# Find process on port 8080
netstat -ano | findstr :8080

# Alternative: use lsof (Linux/Mac)
lsof -i :8080

# Kill the process (note the PID from above)
taskkill /PID <PID> /F

# Or use different ports in docker-compose.yml
```

### Network Connectivity Issues

```bash
# Check network
docker network ls
docker network inspect microservices-net

# Verify service addresses
docker exec api-gateway ping item-service
docker exec api-gateway ping order-service
```

### JSON Parsing Issues in Terminal

```bash
# Install jq for better JSON formatting
# Windows: choco install jq
# Linux: sudo apt-get install jq
# Mac: brew install jq

# Then use with curl
curl http://localhost:8080/items | jq .
```

## Test Coverage Matrix

| Feature | GET | POST | GET {id} | Error Handling |
|---------|-----|------|----------|----------------|
| Items | ✓ | ✓ | ✓ | ✓ |
| Orders | ✓ | ✓ | ✓ | ✓ |
| Payments | ✓ | ✓ | ✓ | ✓ |
| Routing | ✓ | ✓ | ✓ | ✓ |
| Data Persistence | ✓ (in-memory) | ✓ | ✓ | N/A |

## Continuous Testing

### Health Check Script

```bash
#!/bin/bash
# health-check.sh

echo "Checking microservices health..."

# Check API Gateway
if curl -s http://localhost:8080/items > /dev/null; then
  echo "✓ API Gateway healthy"
else
  echo "✗ API Gateway down"
fi

# Check Item Service (via gateway)
if curl -s http://localhost:8080/items | grep -q '\['; then
  echo "✓ Item Service responding"
else
  echo "✗ Item Service not responding"
fi

# Check Order Service
if curl -s http://localhost:8080/orders | grep -q '\['; then
  echo "✓ Order Service responding"
else
  echo "✗ Order Service not responding"
fi

# Check Payment Service
if curl -s http://localhost:8080/payments | grep -q '\['; then
  echo "✓ Payment Service responding"
else
  echo "✗ Payment Service not responding"
fi

echo "Health check complete"
```

## Test Metrics

Document test results:

```
Date: 2026-03-01
Environment: Docker Compose
Java Version: 17

Test Results:
- Item Service: ✓ All endpoints working
- Order Service: ✓ All endpoints working  
- Payment Service: ✓ All endpoints working
- API Gateway: ✓ Routing correctly
- Response Time: Average 50ms
- Data Persistence: ✓ In-memory storage working
- Error Handling: ✓ Proper 404 responses
```

## Next Steps

1. ✅ Start services: `docker-compose up -d`
2. ✅ Verify connectivity: `curl http://localhost:8080/items`
3. ✅ Run test scenarios from this guide
4. ✅ Monitor logs: `docker-compose logs -f`
5. ✅ Document results
6. ✅ Report any issues

All tests should pass with the provided implementation. If any test fails, check logs and service status.
