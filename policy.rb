policy "docker-secrets-redmine-1.0" do
  password = container = nil
  
  group "secrets-managers" do
    owns do
      password = variable "db-password"
    end
  end
  
  layer "redmine" do
    can "execute", password
  end
end
