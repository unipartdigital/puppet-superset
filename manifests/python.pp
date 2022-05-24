# =Class superset::python
class superset::python inherits superset {
  require superset::package
  if downcase($::osfamily) == 'redhat'{
    require superset::selinux
  }

  if !defined(Class['python']) {
    class { 'python':
      version => $python_version,
      pip     => present,
      dev     => present,
    }
  }

  file { $base_dir:
    ensure => directory,
    owner  => $owner,
    group  => $group,
  }

  python::pyvenv { "${base_dir}/venv":
    ensure   => present,
    venv_dir => "${base_dir}/venv",
    version  => $python_version,
    owner    => $owner,
    group    => $group,
    require  => [Class['python'], File[$base_dir]],
  }

  python::pip { $pip_deps:
    ensure       => present,
    virtualenv   => "${base_dir}/venv",
    pip_provider => 'pip3',
    owner        => $owner,
    require      => Python::Pyvenv["${base_dir}/venv"]
  }

  if $package_index_url != undef {
    if $package_index_username != undef and $package_index_password != undef {
      $package_index = "https://${package_index_username}:${package_index_password}@${package_index_url}"
    } else {
      $package_index = "https://${package_index_url}"
    }
  } else {
    $package_index = false
  }

  python::pip { 'apache-superset':
    ensure       => $superset_version,
    extras       => $superset_extras,
    virtualenv   => "${base_dir}/venv",
    pip_provider => 'pip3',
    index        => $package_index,
    install_args => $pip_args,
    owner        => $owner,
    notify       => [Service['gunicorn'], Service['celery']],
    require      => [Python::Pip[$pip_deps]]
  }

  exec { "restorecon -r ${base_dir}/venv/bin":
    command => "restorecon -r ${base_dir}/venv/bin",
    onlyif  => "test `ls -aZ ${base_dir}/venv/bin/gunicorn | grep -c bin_t` -eq 0",
    user    => 'root',
    path    => '/sbin:/usr/sbin:/bin:/usr/bin',
    require => [Python::Pip['apache-superset']]
  }
}
