require "capistrano/setup"

require "capistrano/deploy"
require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/sidekiq'
require 'capistrano3/unicorn'
require 'whenever/capistrano'
require 'thinking_sphinx/capistrano'

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
