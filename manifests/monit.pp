#
# == Class: puppetdb::monit
#
# Setups monit rules for puppetdb
#
class puppetdb::monit
(
    $monitor_email
)
{
    monit::fragment { 'puppetdb-puppetdb.monit':
        modulename => 'puppetdb',
    }
}
