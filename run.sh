#!/bin/bash

# Microservices Lab - Build & Run Script
# Usage: ./run.sh build|up|down|logs

set -e

echo "================================"
echo "Microservices Lab"
echo "SLIIT - CTSE Lab 5"
echo "================================"

case "$1" in
  build)
    echo "Building all services..."
    docker-compose build
    echo "✓ Build complete!"
    ;;
  
  up)
    echo "Starting all services..."
    docker-compose up -d
    sleep 5
    echo "✓ Services started!"
    echo ""
    echo "Services running on:"
    echo "  API Gateway: http://localhost:8080"
    echo "  Item Service: http://localhost:8081/items"
    echo "  Order Service: http://localhost:8082/orders"
    echo "  Payment Service: http://localhost:8083/payments"
    ;;
  
  down)
    echo "Stopping all services..."
    docker-compose down
    echo "✓ Services stopped!"
    ;;
  
  logs)
    echo "Showing logs..."
    docker-compose logs -f
    ;;
  
  status)
    echo "Service status:"
    docker-compose ps
    ;;
  
  test)
    echo "Testing Item Service..."
    curl -s http://localhost:8080/items | json_pp || echo "Items: $(curl -s http://localhost:8080/items)"
    echo ""
    echo "Testing Order Service..."
    curl -s http://localhost:8080/orders | json_pp || echo "Orders: $(curl -s http://localhost:8080/orders)"
    echo ""
    echo "Testing Payment Service..."
    curl -s http://localhost:8080/payments | json_pp || echo "Payments: $(curl -s http://localhost:8080/payments)"
    ;;
  
  *)
    echo "Usage: $0 {build|up|down|logs|status|test}"
    echo ""
    echo "Commands:"
    echo "  build   - Build all Docker images"
    echo "  up      - Start all services"
    echo "  down    - Stop all services"
    echo "  logs    - View service logs"
    echo "  status  - Check service status"
    echo "  test    - Run basic API tests"
    exit 1
    ;;
esac
