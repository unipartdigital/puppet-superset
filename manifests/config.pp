# =Class superset::config
class superset::config inherits superset {
  require superset::celery
  require superset::gunicorn

  $secret_key = seeded_rand_string(64, "${::fqdn}::superset_secret", 'abcdef0123456789')

  file { "${base_dir}/superset_config.py":
    ensure  => present,
    content => template("${module_name}/opt/superset/superset_config.py.erb"),
    owner   => $owner,
    group   => $group,
    notify  => [Service['gunicorn'], Service['celery']]
  }
}
