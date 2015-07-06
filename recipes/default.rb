include_recipe "catchall::webdav"
include_recipe "shells::bash_settings"

file "raise the ulimit for duplicity" do
  action :create
  path ::File.join(::Dir.home(node['current_user']), ".profile.d", "ulimit.sh")
  content "ulimit -n 1024"
  owner node['current_user']
  group node['current_user']
  mode "0700"
end

directory ::File.join(::Dir.home(node['current_user']), ".duplicity") do
  owner node['current_user']
  group node['current_user']
  mode "0750"
end

directory ::File.join(::Dir.home(node['current_user']), ".duply") do
  owner node['current_user']
  group node['current_user']
  mode "0750"
end

execute "copy duply profiles down from webdav" do
  action :run
  command "cp -R #{node['webdav']['mount']}/duplicity/duply/* ~/.duply"
  creates ::File.join(::Dir.home(node['current_user']), ".duply", "webdav", "conf")
  user node['current_user']
end
