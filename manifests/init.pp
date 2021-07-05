# =Class superset
class superset (
  String $admin_email,
  String $admin_user,
  String $admin_pass,
  String $base_dir,
  String $owner,
  String $group,
  String $db_host,
  String $db_name,
  String $db_user,
  String $db_pass,
  String $ldap_server,
  String $ldap_bind_user,
  String $ldap_bind_pass,
  String $ldap_base_dn,
  String $ldap_group_dn,
  String $log_level,
  String $pip_args,
  Integer $concurrency,
  Variant[Integer, Enum['None']] $row_limit,
  Variant[Enum[present, absent, latest], String[1]] $version,
  Boolean $dynamic_plugins,
  Boolean $ldap_enabled,
  Boolean $manage_database,
  Boolean $ldap_filter_login,
  Hash[String, Array[String]] $ldap_roles_mapping,
  Optional[String] $logo_path = undef,
  Optional[String] $ldap_user_filter = undef,
) {
  contain superset::db
  contain superset::package
  contain superset::python
  contain superset::celery
  contain superset::gunicorn
  contain superset::config
  contain superset::install
  contain superset::service
  if downcase($::osfamily) == 'RedHat'{
    contain superset::selinux
  }
}
