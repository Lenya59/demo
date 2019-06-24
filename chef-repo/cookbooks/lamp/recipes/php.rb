#
# Cookbook:: lamp
# Recipe:: php
#
# Copyright:: 2019, The Authors, All Rights Reserved.
# Install PHP and its modules
#package 'https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm'
#package 'http://rpms.remirepo.net/enterprise/remi-release-7.rpm'
#execute 'php_version' do
#  command 'yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm'
#  ignore_failure true
#end

#execute 'php_version' do
#  command 'yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm'
#  ignore_failure true
#end

#execute 'php_version' do
#  command 'yum install yum-utils'
#  ignore_failure true
#end

#yum_repository 'remi-php56' do
#    mirrorlist 'http://rpms.remirepo.net/enterprise/6/remi/mirror'
#    description "Remi's PHP 5.6 RPM repository for Enterprise Linux 5 - $basearch"
#    enabled true
#    gpgcheck true
#    gpgkey 'http://rpms.remirepo.net/RPM-GPG-KEY-remi'
#  end

#  yum_repository 'epel' do
#      mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-5&arch=$basearch'
#      description 'Extra Packages for Enterprise Linux 5 - $basearch'
#      enabled true
#      gpgcheck true
#      gpgkey 'http://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL'
#    end


package 'yum-utils' do
  action :install
end

execute 'php_version' do
  command 'yum-config-manager --enable remi-php56.repo '
  ignore_failure true
end


%w{php php-fpm php-mysql php-xmlrpc php-gd php-pear php-pspell}.each do |pkg|
  package pkg do
    flush_cache before: true
    action :install
    notifies :reload, 'service[httpd]', :immediately
  end
end
