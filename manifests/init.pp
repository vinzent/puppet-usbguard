# usbguard
#
# @summary Install and configure usbguard
#
# @example
#   include usbguard
#
# @param manage_package 
class usbguard(
  Boolean $manage_service = true,
  Boolean $manage_package  = true,
  Boolean $manage_rules_file  = true,
  String  $package_name = 'usbguard',
  String  $service_name = 'usbguard',
  Enum['running', 'stopped'] $service_ensure = 'running',
  # usbguard-daemon.conf settings settings
  String $daemon_audit_file_path = '/var/log/usbguard/usbguard-audit.log',
  Boolean $daemon_device_rules_with_port = false,
  Enum['allow', 'block', 'reject'] $daemon_implicit_policy_target = 'block',
  Array[String] $daemon_ipc_allowed_groups = [ 'wheel' ],
  Array[String] $daemon_ipc_allowed_users = ['root'],
  Enum['allow','block','reject','keep','apply-policy'] $daemon_present_controller_policy = 'keep',
  Enum['allow','block','reject','keep','apply-policy'] $daemon_present_device_policy= 'apply-policy',
  String $daemon_rule_file = '/etc/usbguard/rules-managed-by-puppet.conf',

) {
  contain ::usbguard::install
  contain ::usbguard::config
  contain ::usbguard::service

  Class['::usbguard::install']
  -> Class['::usbguard::config']
  ~> Class['::usbguard::service']

}
