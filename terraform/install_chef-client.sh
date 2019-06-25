#! /bin/bash
sudo yum update
sudo curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -v 14.4.56
chef-client -v
# Keys
sudo mkdir /home/.chef

sudo cp /vagrant/vagrant.pem /home/.chef



#закинуть ековт на авс ноду
sudo cp ekovt.pem /home/.chef


# create a client.rb
sudo touch /home/.chef/client.rb
sudo bash -c "cat <<EOF > /home/.chef/client.rb
  node_name                'ip-10-20-1-239.ec2.internal'
  client_key               '/etc/chef/ekovt.pem'
  validation_client_name   'itadevops'
  validation_key           '/etc/chef/itadevops-validation.pem'
  chef_server_url          'https://manage.chef.io:443/organizations/itadevops'
  syntax_check_cache_path  '/home/.chef/syntax_check_cache'
EOF"


knife ssl fetch -c /home/.chef/client.rb

knife ssl check -c /home/.chef/client.rb

sudo curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.8.1-x86_64.rpm

sudo rpm -vi filebeat-6.8.1-x86_64.rpm
