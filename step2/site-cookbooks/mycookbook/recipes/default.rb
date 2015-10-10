group "users" do
  gid 5000
end

user "testuser" do
  home "/home/testuser"
  gid 5000
  shell "/bin/bash"
end