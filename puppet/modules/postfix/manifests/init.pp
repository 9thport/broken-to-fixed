# Class: postfix
#
# This module manages postfix
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class postfix {
  package { "postfix": 
    ensure => installed
  }
  
  service { "postfix":
    hasrestart => true,
    enable     => true,
    ensure     => running,
    subscribe  => File["/etc/postfix/main.cf"],
  }

  file { '/etc/postfix/main.cf': 
    ensure => file,
    owner => 'root',
    group => 'root',
    mode => '0644',
    # audit => [ owner, group, mode, type, content ],
    content => template("postfix/main.cf.erb"),
    require => Package['postfix'],
  }
}
