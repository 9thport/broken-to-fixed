# Class: grub_mgmt
#
# This module manages grub_mgmt
#
# Parameters: grub_md5_password (the md5 string for booting with custom kernel parameters)
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
# class { 'grub_mgmt': 
#   grub_md5_password => 'put_md5_string_here',
# }
#
class grub_mgmt (
  $grub_md5_password = $grub_mgmt::params::grub_md5_password,
) inherits grub_mgmt::params

{ 
  anchor { 'grub_mgmt::begin': } ->
  class { '::grub_mgmt::config': } ~>
  class { '::grub_mgmt::apply': } ->
  anchor { 'grub_mgmt::end': }
}