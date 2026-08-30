#!/bin/bash
set -e

dnf install -y nginx

cat >/usr/share/nginx/html/index.html <<'EOF'
<!doctype html>
<html>
<head><title>Web Tier</title></head>
<body>
  <h1>WEB TIER - Auto Scaling</h1>
  <p>External ALB -> Web ASG health check OK</p>
</body>
</html>
EOF

systemctl enable --now nginx
