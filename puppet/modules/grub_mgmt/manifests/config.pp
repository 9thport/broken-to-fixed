class grub_mgmt::config inherits grub_mgmt {
  # Ensure the grub file is:
  #   a file
  #   set to the owner
  #   set to the group
  #   set to the proper mode
  file { $grub_file:
    ensure => file,
    owner => "root",
    group => "root",
    mode => '0600',
    # audit => [ owner, group, mode, type, content, ]
  }  
}