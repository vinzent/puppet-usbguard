
# usbguard

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with usbguard](#setup)
    * [What usbguard affects](#what-usbguard-affects)
    * [Beginning with usbguard](#beginning-with-usbguard)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

Install usbguard and configure the daemon and rules.

https://dkopecek.github.io/usbguard/

Usbguard is available for RHEL/CentOS >= 7.4 and Fedora.

## Setup

### What usbguard affects 

* the usbguard package
* the usbguard-daemon.conf file 
* the rules file (by default `/etc/usbguard/rules.conf`)

### Beginning with usbguard  

Just `include ::usbguard` to start without any rule - but it won't 

## Usage

Install, configure some rules and start the service:

```
include ::usbguard

$rule_content = @(CONTENT)
  allow with-interface equals { 08:*:* }
  reject with-interface all-of { 08:*:* 03:00:* }
  reject with-interface all-of { 08:*:* 03:01:* }
  reject with-interface all-of { 08:*:* e0:*:* }
  reject with-interface all-of { 08:*:* 02:*:* }
  | CONTENT

# DON'T DO THIS ON YOUR COMPUTER OR YOU MIGHT LOCK YOU OUT
# this is just an example. :-)
usbguard::rule { 'allow usb disks without keyboard interface':
  rule => $rule_content,
}
```

## Limitations

* The usbguard package for RHEL/CentOS is only available for 7.4 and later 
  or you  need to configure a external repo on your own (this module will 
  never fiddle with your repo config)

## Development

No defined process available. :-) Github pull-request style.
