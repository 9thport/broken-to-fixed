class inittab (
  $default_runlevel = '3',
  $require_password_for_single_user_mode = true,
) {

  case $::osfamily {
    'RedHat', 'CentOS': {

      case $::operatingsystemmajrelease {
        "6": {
          $template_file = 'redhat6.erb'
        }
      }
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat or CentOS")
    }
  }

  # replace the iniitab file with template
  file { "/etc/inittab":
    ensure => file,
    content => template("inittab/${template_file}"),
    mode => 0644,
    owner => 'root',
    group => 'root',
  }

}
