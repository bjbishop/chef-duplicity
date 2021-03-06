include_recipe "catchall::webdav"
include_recipe "shells::bash_settings"

package "duplicity"
package "duply"

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

directory ::File.join(::Dir.home(node['current_user']), ".profile.d") do
  owner node['current_user']
end

passwd = ::File.readlines(::File.join(::Dir.home(node['current_user']), '.box'))[1]

file "webdav secrets" do
  action :create
  path ::File.join(::Dir.home(node['current_user']), ".profile.d", "box50-secrets.sh")
  content "# password for duplicity and duply for use with box.com over webdav
# written by chef #{cookbook_name}::#{recipe_name}
export PASSPHRASE=#{passwd}
export FTP_PASSWORD=#{passwd}
"
  owner node['current_user']
  mode "0700"
  only_if { ::File.exists?(::File.join(::Dir.home(node['current_user']), ".box")) }
end


# directory ::File.join(::Dir.home(node['current_user']), ".secrets") do
#   owner node['current_user']
# end

# execute "move .box secrets file" do
#   action :run
#   command "mv #{::File.join(::Dir.home(node['current_user']), ".box")} #{::File.join(::Dir.home(node['current_user']), ".secrets", "box50-secrets.txt")}"
#   creates ::File.join(::Dir.home(node['current_user']), ".secrets", "box50-secrets.txt")
#   user node['current_user']
#   only_if { ::File.exists?(::File.join(::Dir.home(node['current_user']), ".box")) }
#   notifies :create, "link[webdav .box file]", :delayed
# end

# link "webdav .box file" do
#   action :nothing
#   target_file ::File.join(::Dir.home(node['current_user']), ".box")
#   to ::File.join(::Dir.home(node['current_user']), ".secrets", "box50-secrets.txt")
# end

Chef::Log.info "#{cookbook_name}: Use lunchy to install services:\n
  - #{::File.join(::Dir.home(node['current_user']), ".duplicity", "duply_local_scheduler.plist")}
  - #{::File.join(::Dir.home(node['current_user']), ".duplicity", "duply_webdav_scheduler.plist")}
"

include_recipe "duplicity::restore"
