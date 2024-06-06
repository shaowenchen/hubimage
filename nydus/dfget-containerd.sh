mkdir -p /etc/containerd/certs.d/docker.io

cat >/etc/containerd/certs.d/docker.io/hosts.toml <<EOF
server = "https://docker.io"

[host."http://127.0.0.1:65001"]
  capabilities = ["pull", "resolve"]
  [host."http://127.0.0.1:65001".header]
    X-Dragonfly-Registry = ["https://registry-1.docker.io"]
  [host."https://registry-1.docker.io"]
    capabilities = ["pull", "resolve"]
EOF
