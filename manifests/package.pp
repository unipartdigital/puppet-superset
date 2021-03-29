# =Class superset::package
class superset::package inherits superset {
  $deps = [
    'gcc', 'gcc-c++', 'libffi-devel', 'chromedriver', 'git',
    'openssl-devel', 'cyrus-sasl-devel', 'openldap-devel'
  ]

  package { $deps:
    ensure => present
  }

  file { '/etc/conf.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root'
  }
}
