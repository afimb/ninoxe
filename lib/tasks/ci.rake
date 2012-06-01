namespace :ci do
  task :prepare do
    cp "config/database.yml.ci", "config/database.yml"
  end
  task :build => ["db:migrate", "spec"]
end

