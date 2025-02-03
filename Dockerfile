# استفاده از تصویر پایه GitLab Runner
FROM gitlab/gitlab-runner:latest

# کپی اسکریپت راه‌اندازی
COPY setup_runner.sh /setup_runner.sh

# دادن مجوز اجرایی به اسکریپت
RUN chmod +x /setup_runner.sh

# اجرای اسکریپت راه‌اندازی هنگام شروع کانتینر
ENTRYPOINT ["/setup_runner.sh"]
