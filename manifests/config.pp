#
# == Class: puppetdb::config
#
# Configure PuppetDB
#
class puppetdb::config
(
    $java_heap_size,
    $store_usage,
    $temp_usage,
    $db_password

) inherits puppetdb::params
{
    class { '::puppetdb::config::postgresql':
        db_password => $db_password,
    }

    File {
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
    }

    file { 'puppetdb-puppetdb':
        ensure  => present,
        name    => $::puppetdb::params::init_config_file,
        content => template('puppetdb/puppetdb.erb'),
        require => Class['puppetdb::install'],
        notify  => Class['puppetdb::service'],
    }

    file { 'puppetdb-config.ini':
        ensure  => present,
        name    => $::puppetdb::params::config_ini,
        content => template('puppetdb/config.ini.erb'),
        require => Class['puppetdb::install'],
        notify  => Class['puppetdb::service'],
    }

    file { 'puppetdb-database.ini':
        ensure  => present,
        name    => $::puppetdb::params::database_ini,
        content => template('puppetdb/database.ini.erb'),
        require => Class['puppetdb::config::postgresql'],
        notify  => Class['puppetdb::service'],
    }
}
