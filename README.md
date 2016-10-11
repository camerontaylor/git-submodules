# Mina::GitSubmodules

Plugin for Mina that adds caching for git submodules when deploying

## Installation & Usage

Add this line to your application's Gemfile:

```rb
gem 'mina-git-submodules', require: false
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install mina-git-submodules
```

replace `mina/git` with `mina/git-submodules` in your `config/deploy.rb`:

```rb
require 'mina/bundler'
require 'mina/rails'
require 'mina/git-submodules'
...

task setup: :environment do
  ...
end

desc 'Deploys the current version to the server.'
task deploy: :environment do
  ...
end
```

For existing deploys remove the existing 'scm' folder.
