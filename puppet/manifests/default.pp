#  ============
#  = security =
#  ============
class { 'grub_mgmt': }
class { 'pam_mgmt': }

file { ["/etc/motd", "/etc/issue"]:
  ensure => file,
  content => "ALERT! You are entering into a secured area! Your IP, Login Time, Username has been noted and has been sent to the server administrator! This service is restricted to authorized users only. All activities on this system are logged. Unauthorized access will be fully investigated and reported to the appropriate law enforcement agencies.
  "
}

# set banner for sshd
augeas { "/etc/ssh/sshd_config":
  context => "/files/etc/sshd_config",
  changes => [ "set Banner 'ALERT! You are entering into a secured area! Your IP, Login Time, Username has been noted and has been sent to the server administrator! This service is restricted to authorized users only. All activities on this system are logged. Unauthorized access will be fully investigated and reported to the appropriate law enforcement agencies.'"
  ],
  notify => Service["sshd"],
}

service { "sshd":
  enable => true,
  ensure => running,
  hasrestart => true,
  hasstatus => true,
  require => Package["openssh-server"],
}

package { "openssh-server":
  ensure => installed,
  require => Package["openssh-clients"],
}

package { "openssh-clients":
  ensure => installed,
}

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

# load the php module
class { 'apache::mod::php': }

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
    {
      comment      => 'Disable ability to use TRACE and TRACK methods',
      rewrite_cond => ['%{REQUEST_METHOD} ^(TRACE|TRACK)'],
      rewrite_rule => ['.* - [F]'],
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
class { 'php_mgmt': }

#  =========
#  = MySQL =
#  =========
class { 'mysql_cleaning':
  roots_password => 'broken',
}
