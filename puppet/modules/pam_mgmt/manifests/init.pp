class pam_mgmt {
  case $::osfamily {
    'CentOS', 'RedHat': {
      $pam_system_auth = '/etc/pam.d/system-auth-ac'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} for module '${module_name}'.")
    }
  }

  file { $pam_system_auth:
    ensure  => present,
    content => template('pam_mgmt/system_auth-ac.erb'),
  }
  
}
