include_recipe 'apt'

package 'gcc-4.7'

# NFS cache
package "cachefilesd" do
  action :install
end

file "/etc/default/cachefilesd" do
  content <<-EOS
RUN=yes
  EOS
  action :create
  mode 0755
end

# MySQL
mysql_service 'default' do
  version '5.6'
  port '3306'
  data_dir '/data'
  initial_root_password 'Ch4ng3me'
  action [:create, :start]
end

mysql_client 'default' do
  action :create
end

# add hosts entry
hostsfile_entry '127.0.0.1' do
	hostname  'shop.local.dev'
	action    :create
end

# create directory
directory '/var/www/shop' do
	owner 'www-data'
	group 'vagrant'
	mode '0775'
	recursive true
	action :create
end

include_recipe 'apache2'

# mod php
include_recipe 'apache2::mod_php5'
node.set['apache']['mpm'] = "prefork"

# mod rewrite
include_recipe 'apache2::mod_rewrite'

# install php5 and modules
include_recipe 'php'

# composer
include_recipe 'composer::install'
include_recipe 'composer::self_update'


# create virtual host
web_app 'shop' do
	server_name 'shop.local.dev'
	server_aliases ['shop.local.dev']
	docroot '/var/www/shop'
	cookbook 'apache2'
end



# create dummy content
execute "create dummy site" do
	command "echo '<?php phpinfo(); ?>' > /var/www/shop/index.php"
	cwd "/var/www/shop"
	action :run
end

# fix owner
execute "chown-data-www" do
	command "chown -R www-data:www-data ."
	cwd "/var/www/shop"
	action :run
end

# fix permission
execute "chmod-data-www" do
	command "chmod -R 775 ."
	cwd "/var/www/shop"
	action :run
end
