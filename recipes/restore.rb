passwd = ::File.readlines(::File.join(::Dir.home(node['current_user']), '.box'))[1].chomp

Chef::Log.info "#{cookbook_name}: password is #{passwd}"

duplicity_restore ".apikeys" do
  verbosity 4
  restore_item ".apikeys"
  local_path File.join(::Dir.home(node["current_user"]), "restore")
  remote_path "par2+webdavs://kc0.rjx@gmail.com@dav.box.com/dav/duplicity/"
  age "now"
  restore_as_user node['current_user']
  restore_as_group node['current_user']
  # If restoring files from a backup using a different UID,
  # use the option: --ignore-errors
  duplicity_options [
    "--tempdir /tmp",
    "--no-print-statistics",
    "--numeric-owner",
    "--num-retries 2",
  ]
end
