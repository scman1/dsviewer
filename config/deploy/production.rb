set :ssh_user, 'deploy'
set :ssh_key, '~/.ssh/demo_nsidr_rsa'

server "demo.nsidr.org",
  user: fetch(:ssh_user),
  roles: %w{web db app},
  ssh_options: {
    auth_methods: %w(publickey password),
    keys:fetch(:ssh_key),
    forward_agent: false
  }
