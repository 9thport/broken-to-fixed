class grub_mgmt::apply inherits grub_mgmt {
  # Use augeas to change the value of password.
  # Instead of using a template, this method
  # helps to not disturb the other settings
  # if the OS has other keys and values.
  # eg. kernel changes
  
  augeas { "${grub_file}":
    context => "/files${grub_file}",
    changes => [
      # set the password to use md5 flag
      "set password/md5 ''",
      # set the password value to the contents from params.pp
      "set password $grub_md5_password",
      # insert a comment into the file to indicate variable under puppet control
      #"insert #comment before password",
      #"set #comment[last()] '$grub_md5_password_comment'"
    ],
    require => File[$grub_file],
    # only run if the password is different
    onlyif => "get password != $grub_md5_password",
  } 
}