# =Class superset::gunicorn
class superset::gunicorn inherits superset {
  require superset::python
  require superset::db
  require superset::selinux

  file { '/etc/conf.d/gunicorn':
    ensure  => present,
    content => template("${module_name}/etc/conf.d/gunicorn.erb"),
    owner   => 'root',
    group   => 'root',
    require => File['/etc/conf.d']
  }

  file { '/etc/systemd/system/gunicorn.service':
    ensure  => present,
    content => template("${module_name}/etc/systemd/system/gunicorn.service.erb"),
    owner   => 'root',
    group   => 'root',
  }

  file { '/etc/systemd/system/gunicorn.socket':
    ensure  => present,
    content => file("${module_name}/etc/systemd/system/gunicorn.socket"),
    owner   => 'root',
    group   => 'root',
  }
}
