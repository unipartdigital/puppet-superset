# =Class superset::service
class superset::service inherits superset {
  require superset::install
  require systemd::systemctl::daemon_reload

  service { 'celery':
    ensure  => running,
    enable  => true,
  }

  service { 'gunicorn':
    ensure  => running,
    enable  => true,
  }
}
