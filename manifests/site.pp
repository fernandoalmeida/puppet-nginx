define nginx::site(
  $root,
  $domain,
  $aliases           = [],
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

  $assets_regex      = "^.+\\.(jpe?g|gif|png|ico|js|css)\$",
  $assets_expires    = "30d",
  $assets_log        = "off",

  $charset           = "utf-8",

  $ssl               = false,

  $enable            = true
  ) {

  file {"nginx site ${domain}":
    ensure  => file,
    path    => "/etc/nginx/sites-available/${domain}",
    content => template("nginx/site.conf.erb"),
  }->
  file {"nginx site ${domain} enable":
    ensure  => link,
    path    => "/etc/nginx/sites-enabled/${domain}",
    target  => "/etc/nginx/sites-available/${domain}",
  }
  
}
