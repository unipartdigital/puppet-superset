# =Class superset::package
class superset::package inherits superset {
  $deps = [
    'gcc', 'gcc-c++', 'libffi-devel', 'chromedriver', 'git',
    'dnf-plugins-core', 'fedora-workstation-repositories',
    'openssl-devel', 'cyrus-sasl-devel', 'openldap-devel'
  ]

  package { $deps:
    ensure => present
  }

  exec { 'enable chrome':
    command     => "/usr/bin/dnf config-manager --set-enabled google-chrome",
    require     => Package[$deps]
  }

  package { 'google-chrome-stable':
    ensure  => present,
    require => Exec['enable chrome']
  }

  file { '/etc/conf.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root'
  }
}
