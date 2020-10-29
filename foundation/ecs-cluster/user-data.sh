#!/bin/bash

yum install -y wget jq vim # yum-utils
yum update -y ecs-init

wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm

amazon-cloudwatch-agent-ctl -a start

cat <<'EOF' >> /usr/local/bin/rm-stopped-containers.sh
docker rm $(docker ps --filter "status=exited" -q)
docker volume prune -f
EOF
chmod +x /usr/local/bin/rm-stopped-containers.sh

crontab<<EOF
$(crontab -l)
0 * * * * /usr/local/bin/rm-stopped-containers.sh
EOF


cat <<'EOF' >> /etc/ecs/ecs.config
ECS_CLUSTER=${ecs_cluster_name}
ECS_ENABLE_TASK_IAM_ROLE=true
ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","awslogs"]
ECS_LOGLEVEL=debug
ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=false
ECS_ENABLE_CONTAINER_METADATA=true
ECS_IMAGE_PULL_BEHAVIOR=always
ECS_DISABLE_METRICS=false
ECS_RESERVED_MEMORY=256
EOF

echo 'stop and start ecs...'
systemctl restart docker
systemctl stop ecs
systemctl enable ecs
systemctl start --no-block --now ecs



