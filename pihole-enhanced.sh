#!/bin/bash

# Enhanced Pi-hole Management Script with modern features
# This script provides advanced Pi-hole management capabilities

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Enhanced blocklists for modern threats
ENHANCED_BLOCKLISTS=(
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
    "https://mirror1.malwaredomains.com/files/justdomains"
    "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"
    "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
    "https://hosts-file.net/ad_servers.txt"
    "https://someonewhocares.org/hosts/zero/hosts"
    "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/BaseFilter/sections/adservers.txt"
    "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"
)

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

case "$1" in
    start)
        print_status "Starting enhanced Pi-hole stack..."
        docker-compose -f docker-compose.enhanced.yml up -d
        print_success "Pi-hole stack started!"
        echo
        print_status "Access points:"
        echo "  • Pi-hole Admin: http://localhost:8080/admin"
        echo "  • Pi-hole Metrics: http://localhost:9617/metrics"
        echo "  • Cloudflared DoH: localhost:5054"
        echo "  • Unbound Recursive: localhost:5335"
        ;;
    stop)
        print_status "Stopping Pi-hole stack..."
        docker-compose -f docker-compose.enhanced.yml down
        print_success "Pi-hole stack stopped!"
        ;;
    restart)
        print_status "Restarting Pi-hole stack..."
        docker-compose -f docker-compose.enhanced.yml restart
        print_success "Pi-hole stack restarted!"
        ;;
    logs)
        echo "Select service to view logs:"
        echo "1) Pi-hole"
        echo "2) Cloudflared (DoH)"
        echo "3) Unbound (Recursive)"
        echo "4) Pi-hole Exporter"
        echo "5) All services"
        read -p "Choice (1-5): " choice
        
        case $choice in
            1) docker-compose -f docker-compose.enhanced.yml logs -f pihole ;;
            2) docker-compose -f docker-compose.enhanced.yml logs -f cloudflared ;;
            3) docker-compose -f docker-compose.enhanced.yml logs -f unbound ;;
            4) docker-compose -f docker-compose.enhanced.yml logs -f pihole-exporter ;;
            5) docker-compose -f docker-compose.enhanced.yml logs -f ;;
            *) print_error "Invalid choice" ;;
        esac
        ;;
    status)
        print_status "Pi-hole stack status:"
        docker-compose -f docker-compose.enhanced.yml ps
        echo
        print_status "Pi-hole statistics:"
        docker exec pihole pihole -c -j | jq .
        ;;
    update)
        print_status "Updating Pi-hole stack..."
        docker-compose -f docker-compose.enhanced.yml pull
        docker-compose -f docker-compose.enhanced.yml up -d
        print_success "Pi-hole stack updated!"
        ;;
    enhance-blocklists)
        print_status "Adding enhanced blocklists..."
        for blocklist in "${ENHANCED_BLOCKLISTS[@]}"; do
            print_status "Adding: $blocklist"
            echo "$blocklist" >> adlists.list
        done
        docker exec pihole pihole -g
        print_success "Enhanced blocklists added and updated!"
        ;;
    backup)
        backup_dir="./backups/$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$backup_dir"
        print_status "Creating backup in $backup_dir..."
        
        # Backup Pi-hole configuration
        cp -r ./*.conf ./*.list "$backup_dir/" 2>/dev/null
        
        # Export Pi-hole settings
        docker exec pihole pihole -a -t > "$backup_dir/pihole_teleporter_backup.tar.gz"
        
        print_success "Backup created successfully!"
        ;;
    restore)
        if [ -z "$2" ]; then
            print_error "Usage: $0 restore <backup_directory>"
            exit 1
        fi
        
        if [ ! -d "$2" ]; then
            print_error "Backup directory $2 not found!"
            exit 1
        fi
        
        print_status "Restoring from $2..."
        cp "$2"/*.conf "$2"/*.list ./ 2>/dev/null
        docker-compose -f docker-compose.enhanced.yml restart pihole
        print_success "Restore completed!"
        ;;
    monitor)
        print_status "Opening Pi-hole monitoring dashboard..."
        print_status "Real-time query monitoring:"
        docker exec pihole tail -f /var/log/pihole.log
        ;;
    security-scan)
        print_status "Running security analysis..."
        
        # Check for DNS leaks
        print_status "Checking DNS configuration..."
        dig @localhost google.com | grep "SERVER:"
        
        # Check blocked domains in last 24h
        print_status "Top blocked domains (last 24h):"
        docker exec pihole pihole -t | head -10
        
        # Check query types
        print_status "Query type distribution:"
        docker exec pihole pihole -qt
        
        print_success "Security scan completed!"
        ;;
    *)
        echo "Enhanced Pi-hole Management Script"
        echo "Usage: $0 {start|stop|restart|logs|status|update|enhance-blocklists|backup|restore|monitor|security-scan}"
        echo ""
        echo "Commands:"
        echo "  start              - Start enhanced Pi-hole stack"
        echo "  stop               - Stop Pi-hole stack"
        echo "  restart            - Restart Pi-hole stack"
        echo "  logs               - View service logs"
        echo "  status             - Show detailed status"
        echo "  update             - Update all containers"
        echo "  enhance-blocklists - Add advanced threat protection lists"
        echo "  backup             - Create configuration backup"
        echo "  restore <dir>      - Restore from backup"
        echo "  monitor            - Real-time query monitoring"
        echo "  security-scan      - Run security analysis"
        echo ""
        echo "Enhanced Features:"
        echo "  • DNS-over-HTTPS via Cloudflared"
        echo "  • Recursive DNS via Unbound"
        echo "  • Prometheus metrics export"
        echo "  • Advanced threat protection"
        echo "  • Automated backups"
        echo ""
        echo "Access enhanced Pi-hole at: http://192.168.50.215:8080/admin"
        exit 1
        ;;
esac
