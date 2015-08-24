passwd = ::File.readlines(::File.join(::Dir.home(node['current_user']), '.box'))[1].chomp

duplicity_restore "Restore folder .apikeys into ~/restore" do
  restore_item ".apikeys"
  local_path File.join(::Dir.home(node["current_user"]), "restore")
  remote_path node["duplicity"]["webdav_remote"]
  restore_as_user node['current_user']
  restore_as_group node['current_user']
  remote_path_password passwd
  encryption_password passwd
  # If restoring files from a backup using a different UID,
  # use the option: --ignore-errors
  duplicity_options [
    "--no-print-statistics",
    "--numeric-owner",
  ]
end
