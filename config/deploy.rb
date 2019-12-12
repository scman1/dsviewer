# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "dsviewer"
set :repo_url, "https://github.com/scman1/dsviewer.git"

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Deploy to the user's home directory
set :deploy_to, "/home/deploy/#{fetch :application}"

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'

# Only keep the last 5 releases to save disk space
set :keep_releases, 5

# Clear existing task so we can replace it rather than "add" to it.
Rake::Task["deploy:compile_assets"].clear

namespace :deploy do
  desc 'Compile assets'
  task :compile_assets => [:set_rails_env] do
    # invoke 'deploy:assets:precompile'
    invoke 'deploy:assets:copy_manifest'
    invoke 'deploy:assets:precompile_local'
    invoke 'deploy:assets:backup_manifest'
  end

  namespace :assets do
    local_dir = "./public/assets/"

    # Download the asset manifest file so a new one isn't generated. This makes
    # the app use the latest assets and gives Sprockets a complete manifest so
    # it knows which files to delete when it cleans up.
    desc 'Copy assets manifest'
    task copy_manifest: [:set_rails_env] do
      on roles(fetch(:assets_roles, [:web])) do
        remote_dir = "#{fetch(:ssh_user)}@#{host.hostname}:#{shared_path}/public/assets/"
        ssh_key = "#{fetch(:ssh_key)}"

        run_locally do
          begin
            execute "mkdir -p #{local_dir}"
            execute "scp -i #{ssh_key} '#{remote_dir}.sprockets-manifest-*' #{local_dir}"
          rescue
            # no manifest yet
          end
        end
      end
    end

    desc "Precompile assets locally and then rsync to web servers"
    task :precompile_local do
      # compile assets locally
      run_locally do
        execute "bundle exec rake assets:precompile"
      end

      # rsync to each server
      on roles(fetch(:assets_roles, [:web])) do
        # this needs to be done outside run_locally in order for host to exist
        remote_dir = "#{fetch(:ssh_user)}@#{host.hostname}:#{shared_path}/public/assets"
        ssh_key = "#{fetch(:ssh_key)}"

        run_locally do
          execute "rsync -e 'ssh -i #{ssh_key}' -av #{local_dir} #{remote_dir}"
        end
      end

      # clean up
      run_locally { execute "rm -rf #{local_dir}" }
    end
  end
end