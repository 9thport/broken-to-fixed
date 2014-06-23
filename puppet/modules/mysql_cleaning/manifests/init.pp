class mysql_cleaning (
  # pass root password to be used for cleaning up accounts
  $roots_password = '',
)
{

  # Set resourece ordering of operations
  #
  # 1. fix /var/lib/mysql permissions
  # 2. fix /etc/my.cnf with template
  # 
  File['/var/lib/mysql'] -> File['/etc/my.cnf']

  # make sure the mysql-server package is installed
  package { "mysql-server":
    ensure => installed,
    notify => Service["mysqld"],
  }

  # set the mysqld service to be enabled
  service { "mysqld":
    enable => true,
    ensure => running,
    hasrestart => true,
    hasstatus => true,
    require => File["/etc/my.cnf"],
  }

  # fix the my.cnf file with a template
  file { "/etc/my.cnf":
    owner => 'root',
    group => 'root',
    mode => '0644',
    ensure => file,
    content => template("mysql_cleaning/my.cnf.erb"),
    require => Package["mysql-server"],
  }

  # fix permissions and ignore the mysql.sock
  file { "/var/lib/mysql":
    owner   => 'mysql',
    group   => 'mysql',
    recurse => true,
    notify  => Service["mysqld"],
    ignore  => "mysql.sock"
  }

  # Remove all accounts with blank password
  # SET SQL_LOG_BIN=0   is for disabling logging while issuing commands
  exec { "remove_accounts_with_no_password":
    command => "/usr/bin/mysql -u root -p${roots_password} -e \"SET SQL_LOG_BIN=0; DELETE FROM mysql.user WHERE Password=''\"",
    path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
    unless => "test `/usr/bin/mysql -NB -u root -p${roots_password} -e \"SET SQL_LOG_BIN=0; SELECT COUNT(*) from mysql.user where Password = ''\"` -eq 0",
    require => Service["mysqld"],
  }

  # Create account called 'test' to access the 'test.data' table
  # SET SQL_LOG_BIN=0   is for disabling logging while issuing commands
  exec { "add_test_account_with_priv":
    command => "/usr/bin/mysql -u root -p${roots_password} -e \"SET SQL_LOG_BIN=0; GRANT SELECT ON test.data TO 'test'@'localhost' IDENTIFIED BY 'broken'\"",
    path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
    unless => "test `/usr/bin/mysql -NB -u root -p${roots_password} -e \"SET SQL_LOG_BIN=0; SELECT COUNT(*) FROM mysql.user WHERE User = 'test'\"` -eq 1",
    require => Service["mysqld"],
  }
}