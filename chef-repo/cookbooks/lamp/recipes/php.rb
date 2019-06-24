epelrepo = '/home/epel.rpm'
remirepo = '/home/remi.rpm'

action :install do

  remote_file epelrepo do
    source 'https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm'
    owner 'root'
    group 'root'
    mode '0755'
  end

  remote_file remirepo do
    source 'https://rpms.remirepo.net/enterprise/remi-release-7.rpm'
    owner 'root'
    group 'root'
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

  package %w(php php-mysql php-devel php-gd php-pecl-memcache php-pspell php-snmp php-xmlrpc php-xml) do
    action :install
  end
end
