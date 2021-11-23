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

  file { '/etc/conf.d/celery-beat':
    ensure  => present,
    content => template("${module_name}/etc/conf.d/celery-beat.erb"),
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

  file { '/etc/systemd/system/celery-beat.service':
    ensure  => present,
    content => template("${module_name}/etc/systemd/system/celery-beat.service.erb"),
    owner   => 'root',
    group   => 'root'
  }

    file { ['/var/run/celery', '/var/log/celery', '/var/run/celery-beat', '/var/log/celery-beat']:
      ensure => directory,
      owner  => $owner,
      group  => $group
    }
}
