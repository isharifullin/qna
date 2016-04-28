# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server '85.143.209.109', user: 'deployer', roles: %w{app db web}, primary: true


# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

role :app, %w{deployer@85.143.209.109}
role :web, %w{deployer@85.143.209.109}
role :db,  %w{deployer@85.143.209.109}

set :rails_env, :production
set :stage, :production

# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# Global options
# --------------

set :ssh_options, {
  keys: %w(/home/ildorf/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey password),
  port: 4123
}