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
    $db_password
)
{
    include ::postgresql
    include ::postgresql::install::contrib

    class { '::puppetdb::config::postgresql':
        db_password => $db_password,
}
}
