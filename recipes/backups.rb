directory node[:chef_server_populator][:backup][:dir] do
  recursive true
end

#Upload to Remote Storage
# Include fog
%w(gcc libxml2 libxml2-devel libxslt libxslt-devel).each do |fog_dep|
  package fog_dep do
    only_if{ node[:chef_server_populator][:backup][:remote][:connection] }
  end
end

gem_package 'fog' do
  only_if{ node[:chef_server_populator][:backup][:remote][:connection] }
end

template '/usr/local/bin/chef-server-backup' do
  mode '0755'
end

cron 'Chef Server Backups' do
  command '/usr/local/bin/chef-server-backup'
  node[:chef_server_populator][:backup][:schedule].each do |k,v|
    send(k,v)
  end
end