#!/bin/bash
set -e

dnf install -y nginx

cat >/usr/share/nginx/html/index.html <<'EOF'
<!doctype html>
<html>
<head><title>Application Tier</title></head>
<body>
  <h1>APPLICATION TIER - Auto Scaling</h1>
  <p>Internal ALB -> App ASG health check OK</p>
</body>
</html>
EOF

systemctl enable --now nginx
