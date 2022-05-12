# =Class superset::install
class superset::install inherits superset {
  require superset::config
  require superset::version

  exec { 'superset upgrade':
    command     => join([
      "${base_dir}/venv/bin/superset db upgrade",
    ], ' '),
    cwd         => $base_dir,
    user        => $owner,
    group       => $group,
    path        => '/usr/sbin:/usr/bin:/sbin:/bin',
    environment => [
      "PYTHONPATH=${base_dir}",
      "SUPERSET_CONFIG_PATH=${base_dir}/superset_config.py",
      'FLASK_APP=superset'
    ],
    refreshonly => true,
    subscribe   => File["${base_dir}/exec_checks/installed_superset_version"],
    require     => File[$base_dir],
  }

  exec { 'superset create-admin':
    command     => join([
      "${base_dir}/venv/bin/superset fab create-admin",
      "--username ${admin_user}",
      '--firstname admin',
      '--lastname admin',
      "--email ${admin_email}",
      "--password ${admin_pass}",
    ], ' '),
    cwd         => $base_dir,
    user        => $owner,
    group       => $group,
    path        => '/usr/sbin:/usr/bin:/sbin:/bin',
    environment => [
      "PYTHONPATH=${base_dir}",
      "SUPERSET_CONFIG_PATH=${base_dir}/superset_config.py",
      'FLASK_APP=superset'
    ],
    require     => [Exec['superset upgrade'], File[$base_dir]],
    refreshonly => true,
    subscribe   => File["${base_dir}/exec_checks/installed_superset_version"],
  }

  exec { 'superset init':
    command     => join([
      "${base_dir}/venv/bin/superset init",
    ], ' '),
    cwd         => $base_dir,
    user        => $owner,
    group       => $group,
    path        => '/usr/sbin:/usr/bin:/sbin:/bin',
    environment => [
      "PYTHONPATH=${base_dir}",
      "SUPERSET_CONFIG_PATH=${base_dir}/superset_config.py",
      'FLASK_APP=superset'
    ],
    require     => [Exec['superset create-admin'], File[$base_dir]],
    refreshonly => true,
    subscribe   => File["${base_dir}/exec_checks/installed_superset_version"],
  }

  if ($logo_path) {
    file { "${base_dir}/venv/lib/python${facts['python3_release']}/site-packages/superset/static/assets/images/logo.png":
      ensure  => present,
      source  => $logo_path,
      owner   => $owner,
      group   => $group,
      require => File[$base_dir]
    }
  }
}
