#! /bin/bash
sudo yum update
curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -v 14.4.56
chef-client -v
# Keys
sudo mkdir /home/.chef

sudo cp /vagrant/vagrant.pem /home/.chef

sudo cp ekovt.pem /home/.chef
# create a client.rb
sudo touch /home/.chef/client.rb
sudo bash -c "cat <<EOF > /home/vagrant/.chef/client.rb
  node_name                'ec2-node'
  client_key               '/home/.chef/vagrant.pem'
  validation_client_name   'ekovt'
  validation_key           '/home/.chef/ekovt.pem'
  chef_server_url          'https://manage.chef.io:443/organizations/itadevops'
  syntax_check_cache_path  '/home/.chef/syntax_check_cache'
EOF"


knife ssl fetch -c /home/.chef/client.rb

knife ssl check -c /home/.chef/client.rb



curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.8.1-x86_64.rpm

sudo rpm -vi filebeat-6.8.1-x86_64.rpm
