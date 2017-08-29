# usbguard::install
#
# @private
#
# @summary Install the usbguard package
#
# @example
#   private class - don't use it directly
class usbguard::install {
  if $::usbguard::manage_package {
    package { $::usbguard::package_name:
      ensure => 'present',
    }
  }
}
