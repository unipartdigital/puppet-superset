# =Class superset::selinux
class superset::selinux inherits superset {
  selinux::boolean { 'httpd_can_network_connect': }

  selinux::fcontext { "${base_dir}/venv/bin":
    seltype  => 'bin_t',
    pathspec => "${base_dir}/venv/bin(/.*)?",
  }
}
