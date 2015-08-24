passwd = ::File.readlines(::File.join(::Dir.home(node['current_user']), '.box'))[1]

duplicity_restore ".apikeys" do
  restore_item ".apikeys"
  local_path File.join(::Dir.home(node["current_user"]), "restore")
  remote_path "par2+webdavs://kc0.rjx@gmail.com@dav.box.com/dav/duplicity/"
  remote_path_password passwd
  encryption_password passwd
  age "now"
  restore_as_user node['current_user']
  duplicity_options [
    "--tempdir /tmp",
    "--no-print-statistics",
    "--extra-clean"
  ]
end
