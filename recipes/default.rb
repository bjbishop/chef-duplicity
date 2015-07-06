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

file "box.com public cert file: cacert.pem" do
  action :create
  path ::File.join(::Dir.home(node['current_user']), ".duplicity", "cacert.pem")
  content "-----BEGIN CERTIFICATE-----
MIIE0TCCA7mgAwIBAgIQHAISymlIk/lT3eoOAhQ9kjANBgkqhkiG9w0BAQsFADBE
MQswCQYDVQQGEwJVUzEWMBQGA1UEChMNR2VvVHJ1c3QgSW5jLjEdMBsGA1UEAxMU
R2VvVHJ1c3QgU1NMIENBIC0gRzMwHhcNMTQxMTE0MDAwMDAwWhcNMTgwNTI5MjM1
OTU5WjBgMQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTESMBAGA1UE
BxQJTG9zIEFsdG9zMRIwEAYDVQQKFAlCb3gsIEluYy4xFDASBgNVBAMUC2FwcC5i
b3guY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmirDpXWCz2o/
ehyHkh29TkYjofe4gSn2wSD4m1a3RdUrs17ehSK8cG8nA0kiBSK101r3n/2tnYf2
tD2SUxC8JoH3KOPLxgc6dcL8nSrgLW8o4O9z93x51Z+OAlUyMMAhoduc5LdqdwSS
Xz1IMzGd7zZkarUeR2nGRBJXm42fDT0pksx46uEt66szivvt422MHKxYCD41Yzs3
uO+oyz2BUmOMXv/Ek0wusto9de3v32nFCHC0T34xUmmOePzazJ0CJKXv7FlPZVxe
MxMUycNXIRsdYseCcfSa5MSpsUEFfTyqgmWL+O/DSOzCFMVA7/5hPT1JjDaJ9uYI
gwhM2yGa7wIDAQABo4IBoTCCAZ0wFgYDVR0RBA8wDYILYXBwLmJveC5jb20wCQYD
VR0TBAIwADAOBgNVHQ8BAf8EBAMCBaAwKwYDVR0fBCQwIjAgoB6gHIYaaHR0cDov
L2duLnN5bWNiLmNvbS9nbi5jcmwwgaEGA1UdIASBmTCBljCBkwYKYIZIAYb4RQEH
NjCBhDA/BggrBgEFBQcCARYzaHR0cHM6Ly93d3cuZ2VvdHJ1c3QuY29tL3Jlc291
cmNlcy9yZXBvc2l0b3J5L2xlZ2FsMEEGCCsGAQUFBwICMDUMM2h0dHBzOi8vd3d3
Lmdlb3RydXN0LmNvbS9yZXNvdXJjZXMvcmVwb3NpdG9yeS9sZWdhbDAdBgNVHSUE
FjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwHwYDVR0jBBgwFoAU0m/3lvSFP3I8MH0j
2oV4m6N8WnwwVwYIKwYBBQUHAQEESzBJMB8GCCsGAQUFBzABhhNodHRwOi8vZ24u
c3ltY2QuY29tMCYGCCsGAQUFBzAChhpodHRwOi8vZ24uc3ltY2IuY29tL2duLmNy
dDANBgkqhkiG9w0BAQsFAAOCAQEAyCTcmpVrtMbp0X7bpVst+JDdKmvDeWuBacsP
jJCtyzfl3TCuz4aMIuMMXjWRq7Mjg9dqrMZp5aG0+n7zH82KJOaHZZTqXOa/I1uo
LYUwBoAme7edLZ+ziPHTR/gY8tKruRfyqy9Sqbx0ttsHZNzTnZughZ1hIznFMWU0
57uAZE9tqnNG6UXmKy/h2t2HMreWlR8yV8DbI+pY2WHXOX3VZteF1YxFd5m3s7ir
4l9NRLmmaQBsn6RSClxur9eCvUfXa7Xk/F8Siva965jQ/8VQ+vegpULZ7Hznk2Jm
CZBGkdMmcUmndD4w8b0MZCx3S+lXof/Dv72Jk+nvZEzFbcDVqQ==
-----END CERTIFICATE-----"
  owner node['current_user']
  group node['current_user']
  mode "0640"
end
