#
# Cookbook Name:: home_db
# Recipe:: default
#
# Copyright (c) 2015 Tim Beeler, All Rights Reserved.

package 'mysql-server'

service 'mysqld' do
  action :start
end

template '/etc/my.cnf' do
  source 'my.cnf.erb'
end

bash 'mysql_secure_installation' do
  code <<-EOH
    mysql -uroot <<EOF && touch /var/lib/mysql/.mysql_secure_installation_complete
-- remove anonymous users
DELETE FROM mysql.user WHERE User='';
-- Disallow root login remotely
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
-- Remove test database and access to it
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
-- Reload privilege tables now
FLUSH PRIVILEGES;
EOF
  EOH
  only_if do
    !File.exists?('/var/lib/mysql/.mysql_secure_installation_complete')
  end
end
