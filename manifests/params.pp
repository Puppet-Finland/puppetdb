#
# == Class: puppetdb::params
#
# Setup some variables based on the operating system
#
class puppetdb::params {

    include ::os::params

    # (Currently) OS-agnostic parameters
    $rundir = '/var/run/puppetlabs'
    $config_dir = '/etc/puppetlabs/puppetdb'
    $config_ini = "${config_dir}/conf.d/config.ini"
    $database_ini = "${config_dir}/conf.d/database.ini"
    $service_name = 'puppetdb'
    $pidfile = "${rundir}/puppetdb/puppetdb.pid"

    case $::osfamily {
        'RedHat': {
            $init_config_file = '/etc/sysconfig/puppetdb'
        }
        'Debian': {
            $init_config_file = '/etc/default/puppetdb'
        }
        default: {
            fail("Unsupported operating system: ${::osfamily}")
        }
    }

    if str2bool($::has_systemd) {
        $service_start = "${::os::params::systemctl} start ${service_name}"
        $service_stop = "${::os::params::systemctl} stop ${service_name}"
    } else {
        $service_start = "${::os::params::service_cmd} ${service_name} start"
        $service_stop = "${::os::params::service_cmd} ${service_name} stop"
    }
}
