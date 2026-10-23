#!/bin/bash

# Non-interactive GitLab Runner setup for the Compose service in this repo.
# RUNNER_TOKEN is the runner authentication token (glrt-...). It is never
# baked into the image. GITLAB_URL defaults to the Compose hostname.

GITLAB_URL="${GITLAB_URL:-http://gitlab.local}"

if [ -z "${RUNNER_TOKEN:-}" ]; then
  echo "ERROR: RUNNER_TOKEN is not set." >&2
  echo "Copy .env.example to .env, set RUNNER_TOKEN, and start the stack again." >&2
  exit 1
fi

CONFIG_FILE="/etc/gitlab-runner/config.toml"

# Recreate the config on every start so the mounted file matches the env vars.
echo "Cleaning up old config.toml..."
rm -f "$CONFIG_FILE"

echo "Creating new config.toml..."
cat <<EOF > "$CONFIG_FILE"
[[runners]]
  name = "git_runner"
  url = "$GITLAB_URL"
  token = "$RUNNER_TOKEN"
  executor = "docker"
  [runners.custom_build_dir]
  [runners.docker]
    tls_verify = false
    image = "docker:latest"
    privileged = true
    disable_entrypoint_overwrite = false
    volumes = ["/var/run/docker.sock:/var/run/docker.sock"]
    networks = ["gitlab-network"]
    network_mode = "host"
    extra_hosts = ["gitlab.local:172.18.0.2"]
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
    tag_list = ["ci-cd", "order-tracker"]
EOF

echo "config.toml created successfully!"

# GitLab's first boot is much slower than this pause. Registration is
# retried by restarting the container once GitLab answers.
echo "Waiting for GitLab to be ready..."
sleep 5

gitlab-runner register \
  --non-interactive \
  --url "$GITLAB_URL" \
  --registration-token "$RUNNER_TOKEN" \
  --executor "docker" \
  --description "docker-runner" \
  --docker-image "docker:latest" \
  --docker-privileged \
  --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" \
  --tag-list "ci-cd" \
  --run-untagged \
  --locked="false"

echo "GitLab Runner successfully registered!"

gitlab-runner run
