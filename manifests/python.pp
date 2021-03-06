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
    notify       => [Service['gunicorn'], Service['celery'], File["${base_dir}/exec_checks/installed_superset_version"]],
    require      => [Python::Pip[$pip_deps]]
  }
}
