#
# == Class: puppetdb
#
# Install and configure PuppetDB. It mostly follows the official instructions:
#
# <http://docs.puppetlabs.com/puppetdb/3.1/configure.html>
#
# Note that this class has only been tested on PuppetDB 3.1. Moreover, it is 
# assumed that Puppet Labs apt repositories have been preconfigured, which 
# should be the case on a Puppetmaster.
#
# == Parameters
#
# [*manage*]
#   Whether to manage PuppetDB using puppet. Valid values are true (default) and 
#   false.
# [*manage_monit*]
#   Whether to monitor PuppetDB using monit. Valid values are true (default) and 
#   false.
# [*manage_packetfilter*]
#   Whether to manage packet filtering rules for PuppetDB. Valid values are true 
#   and false (default).
# [*java_heap_size*]
#   Java heap size in megabytes. Defaults to 192.
# [*store_usage*]
#   How much storage PuppetDB is allowed to consume in megabytes. Defaults to 
#   1024.
# [*temp_usage*]
#   How much temporary storage PuppetDB is allowed to consume. Defaults to 512.
# [*db_password*]
#   Password for the postgresql "puppetdb" user.
# [*allow_address_ipv4*]
#   Address/subnet from which to allow connections to PuppetDB (8081/tcp). 
#   Defaults to '127.0.0.1'.
# [*allow_address_ipv6*]
#   Same as above, but for IPv6. Defaults to '::1'.
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD license. See file LICENSE for details.
#
class puppetdb
(
    $manage = true,
    $manage_monit = true,
    $manage_packetfilter = false,
    $java_heap_size = 192,
    $store_usage = 1024,
    $temp_usage = 512,
    $db_password,
    $allow_address_ipv4 = '127.0.0.1',
    $allow_address_ipv6 = '::1',
    $monitor_email = $::servermonitor
)
{

    validate_bool($manage)
    validate_bool($manage_monit)
    validate_bool($manage_packetfilter)

    if $manage {

    # PuppetDB requires postgresql 9.4 or greater, so we need to use 
    # postgresql's own apt/yum repositories.
    class { '::postgresql':
        use_latest_release => true,
    }

    class { '::postgresql::install::contrib':
        use_latest_release => true,
    }

    include ::puppetdb::install

    class { '::puppetdb::config':
        java_heap_size => $java_heap_size,
        store_usage    => $store_usage,
        temp_usage     => $temp_usage,
        db_password    => $db_password,
    }

    include ::puppetdb::service

    if $manage_monit {
        class { '::puppetdb::monit':
            monitor_email => $monitor_email,
        }
    }

    if $manage_packetfilter {
        class { '::puppetdb::packetfilter':
            allow_address_ipv4 => $allow_address_ipv4,
            allow_address_ipv6 => $allow_address_ipv6,
        }
    }

}
}
