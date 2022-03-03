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
  String $smtp_host,
  String $smtp_user,
  String $smtp_pass,
  String $smtp_mail_from,
  String $log_level,
  String $pip_args,
  Variant[Enum['system', 'pypy'], String[1]] $python_version,
  Integer $concurrency,
  Integer $smtp_port,
  Variant[Integer, Enum['None']] $row_limit,
  Variant[Enum[present, absent, latest], String[1]] $superset_version,
  Array[String[1]] $superset_extras,
  Optional[String[1]] $package_index_url = undef,
  Optional[String[1]] $package_index_username = undef,
  Optional[String[1]] $package_index_password = undef,
  Optional[Hash[String, Boolean]] $feature_flags = undef,
  Boolean $ldap_enabled,
  Boolean $smtp_starttls,
  Boolean $smtp_ssl,
  Boolean $manage_database,
  Boolean $ldap_filter_login,
  Hash[String, Array[String]] $ldap_roles_mapping,
  Optional[String] $logo_path = undef,
  Optional[String] $ldap_user_filter = undef,
  Optional[Hash[String, String]] $jinja_context_addons = undef,
  Boolean $enable_js_controls,
) {
  contain superset::db
  contain superset::package
  contain superset::python
  contain superset::celery
  contain superset::gunicorn
  contain superset::config
  contain superset::install
  contain superset::service
  if downcase($::osfamily) == 'redhat'{
    contain superset::selinux
  }

  group { $group:
    ensure => 'present',
  }

  user { $owner:
    ensure     => 'present',
    comment    => 'User designated for running superset',
    groups     => $group,
    home       => "/home/${owner}",
    managehome => true,
  }
}
