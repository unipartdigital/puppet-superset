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
  Integer $concurrency,
  Variant[Integer, Enum['None']] $row_limit,
  Boolean $ldap_enabled,
  Boolean $manage_database,
  Hash[String, Array[String]] $ldap_roles_mapping,
  Optional[String] $logo_path = undef,
) {
  contain superset::db
  contain superset::selinux
  contain superset::package
  contain superset::python
  contain superset::celery
  contain superset::gunicorn
  contain superset::config
  contain superset::install
  contain superset::service
}
