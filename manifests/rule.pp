# Manage a usbguard rule
#
# The usbguard class needs to be included before calling this
# defined type.
#
# @summary Add a usbguard rule
#
# @param rule A line of rules.conf
# @param order Order for the concat resource
define usbguard::rule(
  String $rule = $title,
  String $order = '500',
) {
  if !defined(Class['usbguard']) {
    fail('You must include usbguard before calling usbguard::rule')
  }

  if $::usbguard::manage_rules_file {
    concat::fragment { "${::usbguard::daemon_rule_file} ${title}":
      target  => $::usbguard::daemon_rule_file,
      content => "${rule}\n",
      order   => $order,
    }
  }
}
