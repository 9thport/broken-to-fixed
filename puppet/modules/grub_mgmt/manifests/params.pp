class grub_mgmt::params {
  # Default to password that is same as root's password backwards
  
  # (nekorb)
  
  # Requiring md5 password because we do not want a plain text
  # password floating around.
  # 
  # For security reasons see:
  # http://stackoverflow.com/questions/1240852/is-it-possible-to-decrypt-md5-hashes
  
  $grub_md5_password = '$1$1aOMm1$s.pkA3mKXhQrOTk054e6A/'
  $grub_md5_password_comment = 'This password is under control by puppet server \'$servername\''

  case $::operatingsystem {
    # CentOS and RedHat should be the same
    'CentOS', 'RedHat': {
      $grub_file = '/boot/grub/grub.conf'
      $grub_filename = 'grub.conf'      
    }

    # Place holder for other OS support
    
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name}")
    }    
  }
}