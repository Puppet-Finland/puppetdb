#
# == Class: puppetdb::service
#
# Configures puppetdb service to start on boot
#
class puppetdb::service inherits puppetdb::params {

    service { 'puppetdb':
        ensure  => running,
        name    => $::puppetdb::params::service_name,
        enable  => true,
        require => Class['puppetdb::config'],
    }
}
