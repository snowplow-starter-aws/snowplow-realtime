#!/bin/bash

# python and java need to run bzt for loadtests
yum install -y wget jq vim postgresql.x86_64 python3 python3-devel java-1.8.0-openjdk gcc git
python3 -m pip install --upgrade bzt

# sometimes you might want to re-used the jumphost on development as your docker build box ...
yum install -y amazon-ecr-credential-helper
mkdir /home/ec2-user/.docker
cat >> /home/ec2-user/.docker/config.json << EOF
{
"credsStore": "ecr-login"
}
EOF

amazon-linux-extras install -y docker
usermod -a -G docker ec2-user