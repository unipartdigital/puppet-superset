# =Class superset::service
class superset::service inherits superset {
  require superset::install

  service { 'celery':
    ensure => running,
    enable => true,
  }

  service { 'celery-beat':
    ensure => running,
    enable => true,
  }

  service { 'gunicorn':
    ensure => running,
    enable => true,
  }
}
