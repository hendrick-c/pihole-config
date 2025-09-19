#!/bin/bash

# Pi-hole Management Script
# This script helps manage your Pi-hole Docker container

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

case "$1" in
    start)
        echo "Starting Pi-hole..."
        docker-compose up -d
        echo "Pi-hole started! Access the admin panel at: http://localhost:8080/admin"
        ;;
    stop)
        echo "Stopping Pi-hole..."
        docker-compose down
        ;;
    restart)
        echo "Restarting Pi-hole..."
        docker-compose restart
        ;;
    logs)
        echo "Showing Pi-hole logs..."
        docker-compose logs -f pihole
        ;;
    status)
        echo "Pi-hole container status:"
        docker-compose ps
        ;;
    update)
        echo "Updating Pi-hole..."
        docker-compose pull
        docker-compose up -d
        ;;
    *)
        echo "Pi-hole Management Script"
        echo "Usage: $0 {start|stop|restart|logs|status|update}"
        echo ""
        echo "Commands:"
        echo "  start   - Start Pi-hole container"
        echo "  stop    - Stop Pi-hole container"
        echo "  restart - Restart Pi-hole container"
        echo "  logs    - Show Pi-hole logs"
        echo "  status  - Show container status"
        echo "  update  - Update Pi-hole to latest version"
        echo ""
        echo "Access Pi-hole admin at: http://localhost:8080/admin"
        exit 1
        ;;
esac
