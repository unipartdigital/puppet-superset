# =Class superset::python
class superset::python inherits superset {
  require superset::package
  if downcase($::osfamily) == 'RedHat'{
    require superset::selinux
  }

  class { 'python':
    pip => present,
    dev => present,
  }

  file { $base_dir:
    ensure => directory,
    owner  => $owner,
    group  => $group,
  }

  python::pyvenv { "${base_dir}/venv":
    ensure   => present,
    venv_dir => "${base_dir}/venv",
    version  => 'system',
    owner    => $owner,
    group    => $group,
    require  => [Class['python'], File[$base_dir]],
  }

  $deps = [
    'eventlet',
    'gevent',
    'greenlet',
    'gsheetsdb',
    'gunicorn',
    'pyldap',
    'sqlalchemy',
  ]

  python::pip { 'pystan':
    ensure       => '2.19.1.1',
    virtualenv   => "${base_dir}/venv",
    pip_provider => 'pip3',
    owner        => $owner,
    require      => Python::Pyvenv["${base_dir}/venv"]
  }

  python::pip { $deps:
    ensure       => present,
    virtualenv   => "${base_dir}/venv",
    pip_provider => 'pip3',
    owner        => $owner,
    require      => Python::Pip['pystan']
  }

  python::pip { 'apache-superset':
    ensure       => $version,
    extras       => ['prophet', 'postgres'],
    virtualenv   => "${base_dir}/venv",
    pip_provider => 'pip3',
    install_args => $pip_args,
    owner        => $owner,
    require      => [Python::Pip['pystan'], Python::Pip[$deps]]
  }

  exec { "restorecon -r ${base_dir}/venv/bin":
    command => "restorecon -r ${base_dir}/venv/bin",
    onlyif  => "test `ls -aZ ${base_dir}/venv/bin/gunicorn | grep -c bin_t` -eq 0",
    user    => 'root',
    path    => '/sbin:/usr/sbin:/bin:/usr/bin',
    require => [Python::Pip['apache-superset']]
  }
}
