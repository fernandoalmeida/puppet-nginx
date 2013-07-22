# == Class: nginx
#
# A Puppet module for installing and configuring Nginx.
#
# === Examples
#
#  class { nginx:
#    
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
class nginx {
  
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
  service {'nginx':
    ensure  => running,
  }
  
}
