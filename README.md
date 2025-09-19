# Pi-hole Configuration

This repository contains a basic Pi-hole configuration for network-wide ad blocking and DNS filtering.

## What's Included

- `setupVars.conf` - Main Pi-hole configuration with optimized DNS settings
- `adlists.list` - Curated blocklists for enhanced ad/tracker blocking
- `pihole-FTL.conf` - FTL (Faster Than Light) daemon configuration
- `.gitignore` - Excludes large database files and logs

## Key Features

- **Enhanced Security**: Uses Quad9 DNS (9.9.9.9) with malware protection
- **DNSSEC Enabled**: Validates DNS responses to prevent spoofing
- **Multiple Blocklists**: Includes popular lists for comprehensive blocking
- **Optimized Settings**: Query logging enabled, proper rate limiting

## Setup Instructions

1. **Prerequisites**: Docker installed on your system
2. **Clone this repo**: `git clone https://github.com/hendrick-c/pihole-config.git`
3. **Customize settings**: 
   - Change `WEBPASSWORD` in `setupVars.conf`
   - Update `LOCAL_IPV4` to match your network
4. **Run Pi-hole**:
   ```bash
   # Using Docker Compose (recommended)
   docker-compose up -d
   
   # Or using the management script
   ./pihole.sh start
   ```

## Management Commands

Use the included `pihole.sh` script for easy management:

- `./pihole.sh start` - Start Pi-hole
- `./pihole.sh stop` - Stop Pi-hole  
- `./pihole.sh restart` - Restart Pi-hole
- `./pihole.sh status` - Check status
- `./pihole.sh logs` - View logs
- `./pihole.sh update` - Update to latest version

## Access Pi-hole

- **Web Interface**: http://localhost:8080/admin
- **HTTPS Interface**: https://localhost:8443/admin
- **Current Network IP**: http://192.168.50.215:8080/admin

## Important Notes

- **Security**: Change the default password in `setupVars.conf` before deployment
- **Network Configuration**: Current IP is set to 192.168.50.215
- **Router Setup**: Configure your router to use 192.168.50.215 as primary DNS
- **Auto-restart**: Container will automatically restart after system reboots
- **Maintenance**: Run `./pihole.sh update` periodically to update Pi-hole

## Optimization Tips

- Monitor the admin dashboard for blocked queries
- Add custom blocklists as needed
- Whitelist false positives
- Consider enabling DHCP if Pi-hole will handle IP assignments

Enjoy your ad-free network! 🚫📺