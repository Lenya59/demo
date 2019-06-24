#! /bin/bash
sudo yum update
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>Welcome to DevOps_ITA_demo</h1>" | sudo tee /var/www/html/index.html


# #Install Chef client via URL
# curl -L https://omnitruck.chef.io/install.sh | sudo bash
#
# #Connect node to chef
# ipaddr=$(ifconfig | sed -En 's/127.0.0.1//;s/172.17.*//;s/10.0.*//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
#
# hostname=$(hostname)
#
# chef-client --chef-license accept
