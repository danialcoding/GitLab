#!/bin/bash

# آدرس گیت‌لب
GITLAB_URL="http://gitlab.local"  # این آدرس را به آدرس گیت‌لب خود تغییر دهید
GITLAB_URL_RUNNER="http://gitlab"

# توکن ثبت‌نام رانر
REGISTRATION_TOKEN="glrt-t1_dvyrpySVaZzgsdDUzBaE"  # توکن ثبت‌نام خود را وارد کنید

# مسیر فایل پیکربندی
CONFIG_FILE="/etc/gitlab-runner/config.toml"

# پاک کردن فایل config.toml اگر وجود داشته باشد
echo "Cleaning up old config.toml..."
rm -f $CONFIG_FILE

  

# ایجاد فایل config.toml جدید با تنظیمات اولیه
echo "Creating new config.toml..."
cat <<EOF > $CONFIG_FILE
[[runners]]
  name = "git_runner"
  url = "$GITLAB_URL"
  token = "$REGISTRATION_TOKEN"
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

# پیغام موفقیت در ایجاد config.toml
echo "config.toml created successfully!"

# صبر کردن برای آماده شدن GitLab (20 ثانیه تاخیر)
echo "Waiting for GitLab to be ready..."
sleep 5  # 20 ثانیه تاخیر

# اجرای دستور ثبت‌نام
gitlab-runner register \
  --non-interactive \
  --url "$GITLAB_URL" \
  --registration-token "$REGISTRATION_TOKEN" \
  --executor "docker" \
  --description "docker-runner" \
  --docker-image "docker:latest" \
  --docker-privileged \
  --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" \
  --tag-list "ci-cd" \
  --run-untagged \
  --locked="false"

# پیغام موفقیت
echo "GitLab Runner successfully registered!"

# شروع به اجرای GitLab Runner
gitlab-runner run
