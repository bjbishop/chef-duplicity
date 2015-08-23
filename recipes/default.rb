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

[::File.join(::Dir.home(node['current_user']), ".duplicity"),
 ::File.join(::Dir.home(node['current_user']), ".duply")].each do |dir|
  directory dir do
    owner node['current_user']
    group node['current_user']
    mode "0750"
  end
end

execute "copy duply profiles down from webdav" do
  action :run
  command "cp -R #{node['webdav']['mount']}/duply/* ~/.duply"
  creates ::File.join(::Dir.home(node['current_user']), ".duply", "webdav", "conf")
  creates ::File.join(::Dir.home(node['current_user']), ".duply", "webdav", "exclude")
  user node['current_user']
  retries 10
  retry_delay 10
end

file "box.com public cert file: cacert.pem" do
  action :create
  path ::File.join(::Dir.home(node['current_user']), ".duplicity", "cacert.pem")
  content node['duplicity']['box_com_cacert']
  owner node['current_user']
  group node['current_user']
  mode "0640"
end

file "webdav secrets" do
  action :create
  path ::File.join(::Dir.home(node['current_user']), ".profile.d", "box50-secrets.sh")
  content "export PASSPHRASE=#{::File.readlines(::File.join(::Dir.home(node['current_user']), '.box'))[1]}"
  owner node['current_user']
  mode "0700"
  only_if { ::File.exists?(::File.join(::Dir.home(node['current_user']), ".box")) }
end

Chef::Log.info "#{cookbook_name}: Use lunchy to install services:\n
  - #{::File.join(::Dir.home(node['current_user']), ".duplicity", "duply_local_scheduler.plist")}
  - #{::File.join(::Dir.home(node['current_user']), ".duplicity", "duply_webdav_scheduler.plist")}
"
