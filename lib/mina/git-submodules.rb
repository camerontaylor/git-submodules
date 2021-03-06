require 'mina/default'

set :branch, 'master'
set :remove_git_dir, true
set :remote, 'origin'
set :git_not_pushed_message, -> { "Your branch #{fetch(:branch)} needs to be pushed to #{fetch(:remote)} before deploying" }

namespace :git do
  desc 'Clones the Git repository to the release path.'
  task :clone do
    ensure!(:repository)
    ensure!(:deploy_to)
    ensure!(:branch)
    if set?(:commit)
      comment %{Using git commit \\"#{fetch(:commit)}\\"}
      command %{git clone "#{fetch(:repository)}" . --recursive}
      command %{git checkout -b current_release "#{fetch(:commit)}" --force}
    else
      command %{
        if [ ! -d "#{fetch(:deploy_to)}/scm" ]; then
          echo "-----> Cloning the Git repository"
          #{echo_cmd %[git clone "#{fetch(:repository)}" "#{fetch(:deploy_to)}/scm" --recursive && (cd "#{fetch(:deploy_to)}/scm" && git checkout -b deploy #{fetch(:branch)})]}
        else
          echo "-----> Fetching new git commits"
          #{echo_cmd %[(cd "#{fetch(:deploy_to)}/scm" && git fetch "#{fetch(:repository)}" "#{fetch(:branch)}:#{fetch(:branch)}" --force -u && git reset --hard #{fetch(:branch)})]}
        fi &&
        echo "-----> Updating git submodules" &&
        #{echo_cmd %[(cd "#{fetch(:deploy_to)}/scm" && git submodule init && git submodule sync && git submodule update --init --recursive)]} &&
        echo "-----> Copying to release path (branch: '#{fetch(:branch)}')" &&
        #{echo_cmd %[rsync -lrpt --exclude "*/.git/" "#{fetch(:deploy_to)}/scm/" .]}
      }, quiet: true
    end

    comment %{Using this git commit}
    command %{git rev-parse HEAD > .mina_git_revision}
    command %{git --no-pager log --format="%aN (%h):%n> %s" -n 1}
    if fetch(:remove_git_dir)
      command %{rm -rf .git}
    end
  end

  desc 'Removes the old git scm directory'
  task :remove_cache do
    comment "Removing git scm directory"
    command %{rm -rf "#{fetch(:deploy_to)}/scm" }
  end

  task :revision do
    ensure!(:deploy_to)
    command %{cat #{fetch(:current_path)}/.mina_git_revision}
  end

  task :ensure_pushed do
    run :local do
      comment %{Ensuring everyting is pushed to git}
      command %{
        if [ $(git log #{fetch(:remote)}/#{fetch(:branch)}..#{fetch(:branch)} | wc -l) -ne 0 ]; then
          echo "! #{fetch(:git_not_pushed_message)}"
          exit 1
        fi
      }
    end
  end
end