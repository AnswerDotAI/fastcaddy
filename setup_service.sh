#!/bin/bash
# Create caddy group and user
groupadd --system caddy
useradd --system \
    --gid caddy \
    --create-home \
    --home-dir /var/lib/caddy \
    --shell /usr/sbin/nologin \
    --comment "Caddy web server" \
    caddy

cp "/home/$SUDO_USER/go/bin/caddy" /usr/bin/
chmod a+x /usr/bin/caddy

# Write caddy.service file
cat > /etc/systemd/system/caddy.service << EOF
# See https://caddyserver.com/docs/install for instructions.
[Unit]
Description=Caddy
Documentation=https://caddyserver.com/docs/
After=network.target network-online.target
Requires=network-online.target

[Service]
Type=notify
User=caddy
Group=caddy
ExecStart=/usr/bin/caddy run --environ
TimeoutStopSec=5s
LimitNOFILE=1048576
PrivateTmp=true
ProtectSystem=full
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
EOF

# Set correct permissions for the service file
chmod 644 /etc/systemd/system/caddy.service

systemctl daemon-reload
systemctl enable --now caddy
systemctl status caddy

