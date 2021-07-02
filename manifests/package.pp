# =Class superset::package
class superset::package inherits superset {
  $deps = [
    'gcc', 'gcc-c++', 'libffi-devel', 'chromium', 'chromedriver', 'git',
    'openssl-devel', 'cyrus-sasl-devel', 'openldap-devel'
  ]

  package { $deps:
    ensure => present
  }

  file { '/usr/bin/google-chrome':
    ensure  => 'link',
    target  => '/usr/bin/chromium-browser',
    require => Package[$deps],
  }

  file { '/etc/conf.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root'
  }
}
