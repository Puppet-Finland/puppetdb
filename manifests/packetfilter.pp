#
# == Class: puppetdb::packetfilter
#
# Configures packet filtering rules for PuppetDB
#
class puppetdb::packetfilter
(
    $allow_address_ipv4 = '127.0.0.1',
    $allow_address_ipv6 = '::1'

) inherits puppetdb::params
{
    Firewall {
        chain    => 'INPUT',
        proto    => 'tcp',
        dport    => 8081,
        action   => 'accept',
    }

    firewall { '014 ipv4 accept puppetdb port':
        provider => 'iptables',
        source   => $allow_address_ipv4,
    }

    firewall { '014 ipv6 accept puppetdb port':
        provider => 'ip6tables',
        source   => $allow_address_ipv6,
    }
}
