#
# == Class: puppetdb::install
#
# Install PuppetDB
#
class puppetdb::install inherits puppetdb::params {

    package { 'puppetdb':
        ensure => installed,
    }
}
