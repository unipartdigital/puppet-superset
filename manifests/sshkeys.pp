# =Class superset::ssh
class superset::ssh inherits superset {
  $ssh_key_devs = lookup('ssh_key_devs', Hash[String, String], 'hash')

  file { "/home/${owner}/.ssh/authorized_keys":
    ensure  => present,
    require => File["/home/${owner}/.ssh/"],
  }

  $ssh_key_devs.each |$comment, $key| {
    ssh_authorized_key { $comment:
      ensure => present,
      type   => 'ssh-rsa',
      key    => $key
    }
  }
}
