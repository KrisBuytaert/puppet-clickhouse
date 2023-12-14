# The class installs ClickHouse server and manages service
#
# @summary ClickHouse server class
#
# @param package_name
#   Server package to be installed.
# @param package_ensure
#   Server package ensure. See `ensure` attribute for `package` resource.
# @param service_name
#   Name of the managed service for clickhouse-server.
# @param service_ensure
#   Desired state for `$service_name`, see `ensure` for `service` resource.
# @param service_enable
#   If `$service_name` should be enabled, see `enable` for `service` resource.
# @param config_service_notify
#   If true, every config managed by this module and requires for server restart will trigger service refresh.
# @param purge
#   If set to false then unmanaged files will NOT be removed from the directory during a puppet run.

#
# @example Simple use
#   include clickhouse::keeper
#
# @example Use with params
#   class { 'clickhouse::keeper':
#     package_name   => 'clickhouse-keeper',
#     package_ensure => 'latest',
#     service_name   => 'clickhouse-keeper',
#     service_ensure => false,
#     service_enable => false,
#   }
#
# @author InnoGames GmbH
#
class clickhouse::keeper (
    String[1]                  $package_name          = 'clickhouse-keeper',
    # not needed if server is also installed
    String[1]                  $package_ensure        = 'installed',
    String[1]                  $service_name          = $package_name,
    Variant[Boolean, Enum[
        'running',
        'stopped'
    ]]                         $service_ensure        = 'running',
    Variant[Boolean, Enum[
        'manual',
        'mask'
    ]]                         $service_enable        = true,
    Boolean                    $config_service_notify = true,
    Optional[Stdlib::Unixpath] $conf_dir              = undef,
    Stdlib::Unixpath           $config_dir            = $conf_dir ? {
        undef   => '/etc/clickhouse-keeper',
        default => $conf_d_dir,
    },
    Boolean                    $purge = $clickhouse::purge,

) inherits clickhouse {


    package { $package_name:
        ensure => $package_ensure,
    }


    service { $service_name:
        ensure    => $service_ensure,
        enable    => $service_enable,
    }
}
