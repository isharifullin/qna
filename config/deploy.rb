# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'qna'
set :repo_url, 'git@github.com:Ildorf/qna.git'

set :deploy_to, '/home/deployer/qna'
set :depluy_user, 'deployer'

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/private_pub.yml', 
                                                 'config/private_pub_thin.yml', '.env')
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets',
                                               'public/system', 'public/uploads', 'vendor/bundle')

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      #execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end

namespace :private_pub do
  desc 'Start private_pub server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml start"
        end
      end
    end
  end

  desc 'Stop private_pub server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml stop"
        end
      end
    end
  end

  desc 'Restart private_pub server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml restart"
        end
      end
    end
  end
end

after 'deploy:restart', 'private_pub:restart'