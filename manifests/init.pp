# usbguard
#
# @summary Install and configure usbguard
#
# @param manage_package Should the module manage the package or not
# @param manage_service Should the module manage the service or not
# @param manage_rules_file Should the module manage the rules file or not.
#   If set to false usbguard::rule will not manage the rules and also
#   rules passed by the rules param of this class will be ignored.
# @param package_name Name of the package containing usbguard
# @param service_name Name of the service.
# @param service_ensure Should the service be running or stopped. Stopped will
#   also disable the service.
# @param daemon_audit_file_path Path to the usbguard audit log file.
#   AuditFilePath setting of usbguard-daemon.conf
# @param daemon_device_rules_with_port DeviceRulesWithPort setting of
#   usbguard-daemon.conf
# @param daemon_implicit_policy_target ImplicitPolicyTarget setting of
#   usbguard-daemon.conf
# @param daemon_ipc_allowed_groups  IPCAllowedGroups setting of
#   usbguard-daemon.conf
# @param daemon_ipc_allowed_users  IPCAllowedUsers setting of
#   usbguard-daemon.conf
# @param daemon_present_controller_policy PresentControllerPolicy
#   setting of usbguard-daemon.conf
# @param daemon_present_device_policy PresentDevicePolicy setting
#   of usbguard-daemon.conf
# @param daemon_rule_file Path to the rules file. RuleFile setting
#   of usbguard-daemon.conf
# @param rules Array of strings with rules to pass to usbguard::rule
#
# @example 
#   include ::usbguard
#
# @example pass rules class param
#   class { 'usbguard':
#     rules => [ 
#       'allow with-interface equals { 08:*:* }',
#       'reject with-interface all-of { 08:*:* 03:00:* }',
#     ],
#   }
#
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
  String $daemon_rule_file = '/etc/usbguard/rules.conf',

  # rules to provide by hiera/lookup or as class param
  Optional[Array[String]] $rules = undef,
) {
  contain ::usbguard::install
  contain ::usbguard::config
  contain ::usbguard::service

  Class['::usbguard::install']
  -> Class['::usbguard::config']
  ~> Class['::usbguard::service']

  if $rules != undef {
    $rules.each |$rule| {
      ::usbguard::rule { $rule: }
    }
  }
}
