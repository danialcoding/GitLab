###### for run

sudo docker-compose up -d

sudo docker-compose up --build

sudo docker-compose ps

sudo docker ps

http://localhost


############# admin pass 
sudo docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password


root
Password: 0hXB5j986TzIzX1F029O7SvULb/nTeuoEZZaHgC2VLY=



#############

helm repo add gitlab https://charts.gitlab.io
helm repo update


################################### values.yaml
gitlabUrl: http://localhost
runnerRegistrationToken: glrt-t1_-wyX1uVh2ab2ny6KVJfE

replicas: 2

runners:
  config: |
    [[runners]]
      name = "kubernetes-runner"
      executor = "kubernetes"
      [runners.kubernetes]
        namespace = "default"
        image = "alpine:latest"

imagePullPolicy: Always


######################################## install & uninstall gitlab with helm chart 

helm uninstall gitlab-runner --namespace default


helm install gitlab-runner gitlab/gitlab-runner --namespace default \
  --set gitlabUrl=http://localhost \
  --set runnerRegistrationToken=glrt-t1_-wyX1uVh2ab2ny6KVJfE


helm upgrade gitlab-runner \
    --set gitlabUrl=http://localhost,runnerRegistrationToken=glrt-t1_-wyX1uVh2ab2ny6KVJfE \
    gitlab/gitlab-runner --namespace default



orrrrrrrrr


helm pull gitlab/gitlab-runner --untar

helm install gitlab-runner gitlab/gitlab-runner --namespace default \
  --set gitlabUrl=http://localhost \
  --set runnerRegistrationToken=glrt-t1_-wyX1uVh2ab2ny6KVJfE



######################################### runner config for docker compose 
docker exec -it gitlab-runner gitlab-runner register

http://gitlab


glrt-t3_SPRcPt6Ls4Lj-aJ258cP


gitlab-runner

docker

node:16


################################################### manual setting
sudo docker exec -it gitlab-runner bash

apt-get update && apt-get install nano


nano /etc/gitlab-runner/config.toml


[[runners]]
  name = "git_runner"
  url = "http://localhost/"
  token = "glrt-t1_-wyX1uVh2ab2ny6KVJfE"
  executor = "docker"
  [runners.custom_build_dir]
  [runners.docker]
    tls_verify = false
    image = "docker:latest"
    privileged = true
    disable_entrypoint_overwrite = false
    volumes = ["/var/run/docker.sock:/var/run/docker.sock"]
    networks = ["gitlab-network"]
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]

echo "[[runners]]
  name = "git_runner"
  url = "http://localhost/"
  token = "glrt-t1_-wyX1uVh2ab2ny6KVJfE"
  executor = "docker"
  [runners.custom_build_dir]
  [runners.docker]
    tls_verify = false
    image = "docker:latest"
    privileged = true
    disable_entrypoint_overwrite = false
    volumes = ["/var/run/docker.sock:/var/run/docker.sock"]
    networks = ["gitlab-network"]
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs] " > /etc/gitlab-runner/config.toml


sudo docker restart gitlab-runner


sudo gitlab-runner register


sudo gitlab-runner status

glrt-t1_dvyrpySVaZzgsdDUzBaE