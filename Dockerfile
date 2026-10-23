# Custom GitLab Runner image. The entrypoint registers, then runs the runner.
FROM gitlab/gitlab-runner:latest

COPY setup_runner.sh /setup_runner.sh

RUN chmod +x /setup_runner.sh

ENTRYPOINT ["/setup_runner.sh"]
