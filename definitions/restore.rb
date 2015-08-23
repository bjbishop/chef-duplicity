define :duplicity_restore, :verbosity => 3,
       :restore_item => nil,
       :remote_path => nil,
       :local_path => "restore",
       :age => "now",
       :restore_as_user => "",
       :duplicity_options => [],
       :remote_path_password => nil,
       :encryption_password => nil do

  directory params[:local_path] do
    recursive true
  end

  duplicity_cmd = "FTP_PASSWORD=#{params[:remote_path_password]}" if
    params[:remote_path_password]
  duplicity_cmd = " PASSPHRASE=#{params[:encryption_password]}" if
    params[:encryption_password]
  duplicity_cmd = " duplicity"
  params[:duplicity_options].each { |opt| duplicity_cmd << " #{opt}" }
  duplicity_cmd << " --verbosity #{params[:verbosity]}"
  duplicity_cmd << " --file-to-restore #{params[:restore_item]}"
  duplicity_cmd << " #{params[:remote_path]}"
  duplicity_cmd << " #{params[:local_path]}"
  duplicity_cmd << " --time #{params[:age]}"

  execute "Restore #{params[:restore_item]} to #{params[:local_path]}" do
    action :run
    command duplicity_cmd
    cwd ::Dir.home(params[:restore_as_user])
    user params[:restore_as_user]
  end
end
