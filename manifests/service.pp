# usbguard::service
#
# @private
#
# @summary Manage the usbguard service
#
# @example
#   this is a private class - don't use directly
class usbguard::service {
  if $::usbguard::manage_service {
    $enable_param = $::usbguard::service_ensure ? {
      'stopped' => false,
      default   => true,
    }

    service { $::usbguard::service_name:
      ensure => $::usbguard::service_ensure,
      enable => $enable_param,
    }
  }
}
