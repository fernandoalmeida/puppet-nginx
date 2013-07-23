# == Class: nginx
#
# A Puppet module for installing and configuring Nginx.
#
# === Examples
#
#  class {"nginx":
#    worker_processes => 10,
#    worker_connections = 2048,
#  }
#
# === Authors
#
# Fernando Almeida <fernando@fernandoalmeida.net>
# 
# === Copyright
# 
# Copyright 2013 Fernando Almeida, unless otherwise noted.
#
class nginx(
  $user               = "www-data",
  $worker_processes   = 4,
  $worker_connections = 768,
  $multi_accept       = 'on',
  $keepalive_timeout  = 65,
  $access_log         = "/var/log/nginx/access.log",
  $error_log          = "/var/log/nginx/error.log",
  $gzip               = "on",
  $gzip_types         = "text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript"
  ) {
  
  exec {"nginx-apt-key":
    command => "wget --quiet -O - http://nginx.org/keys/nginx_signing.key | apt-key add -",
    unless  => "apt-key list | grep nginx",
  }->  
  file {'nginx.list':
    ensure  => file,
    path    => '/etc/apt/sources.list.d/nginx.list',
    content => '
    deb http://nginx.org/packages/ubuntu/ raring nginx
    deb-src http://nginx.org/packages/ubuntu/ raring nginx
    ',
  }->  
  exec {'nginx-apt-get-update':
    command     => "apt-get update",
    refreshonly => true,
  }->
  package {'nginx':
    ensure  => installed,
  }->
  file {'nginx.conf':
    ensure  => file,
    path    => '/etc/nginx/nginx.conf',
    content => template("nginx/nginx.conf.erb"),
  }->
  service {'nginx':
    ensure     => running,
    enable     => true,
    hasrestart => true,
  }
  
}
