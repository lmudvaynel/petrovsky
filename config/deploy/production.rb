role :web, "83.69.233.88"
role :app, "83.69.233.88"
role :db,  "83.69.233.88", :primary => true

set :rails_env, "production"
set :branch, "new-apt"

set :deploy_to, "#{base_directory}/#{application}_#{stage}"

set :keep_releases, 30

set :current_path, File.join(deploy_to, current_dir) #fix for capistrano-unicorn

after 'deploy:update_code', 'deploy:migrate'
