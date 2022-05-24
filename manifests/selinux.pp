# =Class superset::selinux
class superset::selinux inherits superset {
  require superset::python

  if $superset::manage_selinux {
    exec { "restorecon -r ${base_dir}/venv/bin":
      command => "restorecon -r ${base_dir}/venv/bin",
      onlyif  => "test `ls -aZ ${base_dir}/venv/bin/gunicorn | grep -c bin_t` -eq 0",
      user    => 'root',
      path    => '/sbin:/usr/sbin:/bin:/usr/bin',
    }

    selinux::boolean { 'httpd_can_network_connect': }

    selinux::fcontext { "${base_dir}/venv/bin":
      seltype  => 'bin_t',
      pathspec => "${base_dir}/venv/bin(/.*)?",
    }
  }
}
