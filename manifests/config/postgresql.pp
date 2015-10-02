#
# == Class: puppetdb::config::postgresql
#
# Setup postgresql database and user for use with PuppetDB
#
class puppetdb::config::postgresql
(
    $db_password

) inherits puppetdb::params
{
    # Create a database user for PuppetDB
    postgresql_psql { 'CREATE ROLE puppetdb':
        command => "CREATE ROLE puppetdb LOGIN NOCREATEDB NOCREATEROLE NOSUPERUSER ENCRYPTED PASSWORD \'${db_password}\'",
        unless  => "SELECT rolname FROM pg_roles WHERE rolname='puppetdb'",
        require => Class['postgresql'],
    }

    # Create the puppetdb database
    postgresql_psql { 'CREATE DATABASE puppetdb':
        command => "CREATE DATABASE puppetdb WITH OWNER=puppetdb ENCODING='UTF8'",
        unless  => "SELECT datname FROM pg_database WHERE datname='puppetdb'",
        require => Postgresql_psql['CREATE ROLE puppetdb'],
    }

    # Install the regexp optimized index extension
    postgresql_psql { 'CREATE EXTENSION pg_trgm':
        command => 'CREATE EXTENSION pg_trgm',
        unless  => "SELECT extname FROM pg_extension WHERE extname='pg_trgm'",
        require => [ Class['postgresql'], Class['postgresql::install::contrib'] ],
    }

    # The location of pg_hba.conf changes depending on postgresql version. That, 
    # in turn depends on the OS and on whether postgresql project's apt/yum 
    # repositories are active.
    $pg_hba_conf = $::postgresql::use_latest_release ? {
        true    => $::postgresql::params::latest_pg_hba_conf,
        false   => $::postgresql::params::pg_hba_conf,
        default => $::postgresql::params::pg_hba_conf,
    }

    # Ensure this user can access the database 
    augeas { 'puppetdb-pg_hba.conf':
        context => "/files${pg_hba_conf}",
        changes =>
        [ 'ins 0435 after 1',
          'set 0435/type local',
          'set 0435/database puppetdb',
          'set 0435/user puppetdb',
          'set 0435/method password'
        ],
        lens    => 'Pg_hba.lns',
        incl    => $pg_hba_conf,
        onlyif  => "match *[user = 'puppetdb'] size == 0",
        notify  => Class['postgresql::service'],
    }
}
