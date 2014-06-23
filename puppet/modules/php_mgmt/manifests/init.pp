# Class: php_mgmt
#
# This module manages php_mgmt
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class php_mgmt (
  $expose_php_flag = 'Off',
  
) {
  package { "php":
    ensure => 'latest',
  }

  file { "/etc/php.ini":
    content => template("php_mgmt/php.ini.erb"),
    require => Package['php'],
  }
}
