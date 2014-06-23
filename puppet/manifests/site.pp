  package { "openssh-clients":
    ensure => installed,
  }

  class { 'grub_mgmt': }
  class { 'pam_mgmt': }

  class { 'inittab': 
    default_runlevel => '3',
    require_password_for_single_user_mode => true,
  }

  #  ====================
  #  = postfix settings =
  #  ====================
  class { 'postfix': }

  #  ===================
  #  = apache settings =
  #  ===================
  class { 'apache': 
    server_signature => 'Off',
    server_tokens => 'Prod',
    default_vhost => false,
    service_enable => true,
  }

  #  =================
  #  = apache vhosts =
  #  =================
  apache::vhost { 'php-welcome-application':
    port                => '80',
    docroot             => '/var/www/html/',
    directories         => { path => '/var/www/html', order => ['allow', 'deny'] },
    access_log_file     => "php-welcome-application-access.log",
    rewrites => [
      {
        comment      => 'Redirect urls not matching data.php or starting with images from / to /data.php',
        rewrite_cond => ['%{REQUEST_URI} !(/data\.php|images)'],
        rewrite_rule => ['^(.*)$ /data.php?id=1 [L]'],
      },
   ],
  }

  exec { "move .htaccess files":
    command => "/bin/mv /var/www/html/.htaccess /var/www/html/.htaccess_disabled_by_automation",
    path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
    onlyif => "test -f /var/www/html/.htaccess",
  }

  #  ====================
  #  = php.ini settings =
  #  ====================