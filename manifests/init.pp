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
# [*java_heap_size*]
#   Java heap size in megabytes. Defaults to 192.
# [*store_usage*]
#   How much storage PuppetDB is allowed to consume in megabytes. Defaults to 
#   1024.
# [*temp_usage*]
#   How much temporary storage PuppetDB is allowed to consume. Defaults to 512.
# [*db_password*]
#   Password for the postgresql "puppetdb" user.
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
    $java_heap_size = 192,
    $store_usage = 1024,
    $temp_usage = 512,
    $db_password,
    $monitor_email = $::servermonitor
)
{

    validate_bool($manage)
    validate_bool($manage_monit)

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

}
}
