epelrepo = '/home/ec2-user/epel.rpm'
remirepo = '/home/ec2-user/remi.rpm'

action :install do

  remote_file epelrepo do
    source 'https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm'
    owner 'ec2-user'
    group 'ec2-user'
    mode '0755'
  end

  remote_file remirepo do
    source 'https://rpms.remirepo.net/enterprise/remi-release-7.rpm'
    owner 'ec2-user'
    group 'ec2-user'
    mode '0755'
  end

  package epelrepo do
    action :install
  end

  package remirepo do
    action :install
  end

  execute 'set php version to 73' do
    command 'sudo yum-config-manager --enable remi-php73'
    action :run
  end


%w{php php-fpm php-mysql php-xmlrpc php-gd php-pear php-pspell}.each do |pkg|
  package pkg do
    flush_cache before: true
    action :install
    notifies :reload, 'service[httpd]', :immediately
  end
end
