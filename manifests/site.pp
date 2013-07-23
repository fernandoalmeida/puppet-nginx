define nginx::site(
  $server_name,
  $root,
  $listen            = 80,
  $default           = false,

  $access_log        = false,

  $proxy_pass        = false,
  $proxy_redirect    = "off",
  $proxy_set_headers = {
    "Host"      => "\$host",
    "X-Real-IP" => "\$remote_addr"
  },

  $error_page        = "404  /404.html",

  $assets_regex      = "^.+\\.(jpg|jpeg|gif)\$",
  $assets_expires    = "30d",
  $assets_log        = "off",

  $charset           = "utf-8",

  $ssl               = false,

  $enable            = true
  ) {

  file {"nginx site ${server_name}":
    ensure  => file,
    path    => "/etc/nginx/sites-available/${server_name}",
    content => template("nginx/site.conf.erb"),
  }->
  file {"nginx site ${server_name} enable":
    ensure  => link,
    path    => "/etc/nginx/sites-enabled/${server_name}",
    target  => "/etc/nginx/sites-available/${server_name}",
  }
  
}
