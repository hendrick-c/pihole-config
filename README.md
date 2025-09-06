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
   docker run -d \
     --name pihole \
     -p 53:53/tcp -p 53:53/udp \
     -p 80:80 \
     -v "$(pwd):/etc/pihole/" \
     --cap-add=NET_ADMIN \
     --restart=unless-stopped \
     pihole/pihole:latest
   ```

## Important Notes

- **Security**: Change the default password before deployment
- **Network Configuration**: Update IP addresses to match your network
- **Router Setup**: Configure your router to use Pi-hole as primary DNS
- **Maintenance**: Run `pihole -g` periodically to update blocklists

## Optimization Tips

- Monitor the admin dashboard for blocked queries
- Add custom blocklists as needed
- Whitelist false positives
- Consider enabling DHCP if Pi-hole will handle IP assignments

Enjoy your ad-free network! 🚫📺