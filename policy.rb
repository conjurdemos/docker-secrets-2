policy "docker-secrets-redmine-1.0" do
  password = container = nil
  
  group "secrets-managers" do
    owns do
      password = variable "db-password"
    end
  end
  
  container = host "container/0"
  
  layer "redmine" do
    add_host container
    
    can "execute", password
  end
end
