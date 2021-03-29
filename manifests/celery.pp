# =Class superset::celery
class superset::celery inherits superset {
  require superset::python
  require superset::db

  file { '/etc/conf.d/celery':
    ensure  => present,
    content => template("${module_name}/etc/conf.d/celery.erb"),
    owner   => 'root',
    group   => 'root',
    require => File['/etc/conf.d']
  }

  file { '/etc/systemd/system/celery.service':
    ensure  => present,
    content => template("${module_name}/etc/systemd/system/celery.service.erb"),
    owner   => 'root',
    group   => 'root'
  }

  file { ['/var/run/celery', '/var/log/celery']:
    ensure => directory,
    owner  => $owner,
    group  => $group
  }
}
