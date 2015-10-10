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

# create virtual host
web_app 'shop' do
	server_name 'shop.local.dev'
	server_aliases ['shop.local.dev']
	docroot '/var/www/shop'
	cookbook 'apache2'
end

# create dummy content
execute "create dummy site" do
	command "echo 'hello' > /var/www/shop/index.html"
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