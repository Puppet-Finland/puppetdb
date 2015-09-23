#
# == Class: puppetdb::params
#
# Setup some variables based on the operating system
#
class puppetdb::params {

    include ::os::params

    # (Currently) OS-agnostic parameters
    $config_dir = '/etc/puppetlabs/puppetdb'
    $config_ini = "${config_dir}/conf.d/config.ini"
    $database_ini = "${config_dir}/conf.d/database.ini"
    $service_name = 'puppetdb'

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
}
