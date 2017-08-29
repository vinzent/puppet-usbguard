# usbguard::config
#
# @private
#
# @summary A short summary of the purpose of this class
#
# @example
#   this is a private class
class usbguard::config {
  $ipc_allowed_users = join($::usbguard::daemon_ipc_allowed_users, ' ')
  $ipc_allowed_groups= join($::usbguard::daemon_ipc_allowed_groups, ' ')

  $daemon_conf = @("CONTENT")
    # Managed by puppet
    RuleFile=${::usbguard::daemon_rule_file}
    ImplicitPolicyTarget=${::usbguard::daemon_implicit_policy_target}
    PresentDevicePolicy=${::usbguard::daemon_present_device_policy}
    PresentControllerPolicy=${::usbguard::daemon_present_controller_policy}
    IPCAllowedUsers=${ipc_allowed_users}
    IPCAllowedGroups=${ipc_allowed_groups}
    DeviceRulesWithPort=${::usbguard::daemon_device_rules_with_port}
    AuditFilePath=${::usbguard::daemon_audit_file_path}
    | CONTENT

  file { '/etc/usbguard/usbguard-daemon.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => $daemon_conf,
  }

  if $::usbguard::manage_rules_file {
    # unfortunatly no comments allowed in the rules file (v0.7)
    # can't add header "Managed by puppet"
    concat { $::usbguard::daemon_rule_file:
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
    }
  }
}
