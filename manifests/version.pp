class superset::version inherits superset {
  $exec_checks_dir = "${base_dir}/exec_checks"

  file { $exec_checks_dir:
    ensure  => directory,
    owner   => $owner,
    group   => $group,
    require => File[$base_dir],
  }

  file { "${exec_checks_dir}/installed_superset_version":
    content => $superset::superset_version,
    require => File[$exec_checks_dir],
  }
}
