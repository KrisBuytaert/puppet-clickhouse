# Top level class for ClickHouse DBMS installation and management.
#
# @summary this class allows you to install ClickHouse DB's client, server and keeper (the package repository is the consumer's job)
#
# @param server [Boolean]
#   Is clickhouse-server should be installed or not. It won't be installed by default, because some time you need the client only.
# @param client [Boolean]
#   Is clickhouse-client should be installed or not.
# @param service_ensure
#   Passed to clickhouse::server's service_ensure (running or stopped).
# @param service_enable
#   Passed to clickhouse::server's service_enable (false keeps it from starting at boot).
# @param user
#   User for configs owning. Strongly recommended staying default.
#
#   It's highly unrecommended to change default user, but feel free to shot in a knee.
#   You have to adjust as well the data directory and the whole configs everywhere.
# @param group
#   Group for configs, see `user` parameter.
#
# @example Simple use
#   include clickhouse
#
# @example Install server and client
#   class { 'clickhouse':
#     server => true,
#   }
#
# @example Install everything (the consumer provides the package repository)
#   class { 'clickhouse':
#     server => true,
#     client => true,
#   }
#
# @author InnoGames GmbH
#
class clickhouse (
    Boolean   $server            = false,
    Boolean   $client            = true,
    Boolean   $keeper            = true,
    Boolean   $manage_package     = true,
    Boolean   $purge             = true,
    Enum['running', 'stopped'] $service_ensure = 'running',
    Boolean   $service_enable    = true,
    String[1] $user        = 'clickhouse',
    String[1] $group       = $user,
    String    $keeper_packagename = 'clickhouse-keeper',
) {

    if $server {
        class { 'clickhouse::server':
            service_ensure => $service_ensure,
            service_enable => $service_enable,
        }
    }

    if $client {
        include clickhouse::client
    }


    if $keeper {
        class {'clickhouse::keeper':
          manage_package => $manage_package,
          package_name   => $keeper_packagename,
        }
    }

}
