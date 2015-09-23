#
# == Class: puppetdb
#
# Install and configure PuppetDB
#
# This class has only been tested on PuppetDB 3.1
#
class puppetdb
(
    $db_password
)
{

    include ::postgresql

    class { '::puppetdb::config::postgresql':
        db_password => $db_password,
}
}
