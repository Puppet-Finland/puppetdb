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
class puppetdb
(
    $java_heap_size = 192,
    $store_usage = 1024,
    $temp_usage = 512,
    $db_password
)
{
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
}
