#! /bin/bash

sudo yum update
curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -v 14.4.56



curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.8.1-x86_64.rpm

sudo rpm -vi filebeat-6.8.1-x86_64.rpm
