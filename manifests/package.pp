# =Class superset::package
class superset::package inherits superset {

  if downcase($::osfamily) == 'redhat'{
    $pre_deps = [
      'dnf-plugins-core',
      'fedora-workstation-repositories'
    ]
    package { $pre_deps:
      ensure => present
    }

    exec { 'enable chrome':
      command => 'dnf config-manager --set-enabled google-chrome',
      user    => 'root',
      group   => 'root',
      path    => '/usr/sbin:/usr/bin:/sbin:/bin',
      require => Package[$pre_deps],
    }

    $base_deps = [
      'cyrus-sasl-devel',
      'gawk',
      'gcc-c++',
      'gcc',
      'google-chrome-stable',
      'libffi-devel',
      'openldap-devel',
      'openssl-devel',
      'systemd-devel',
    ]

    if 'mysql' in $superset_extras {
      # `mysqlclient` dependencies, cf. https://pypi.org/project/mysqlclient/
      $mysql_deps = ['python3-devel', 'mysql-devel']
    } else {
      $mysql_deps = []
    }

    package { $deps:
      ensure  => present,
      require => Exec['enable chrome'],
    }

  } elsif downcase($::osfamily) == 'debian'{
    $base_deps = [
      'gawk',
      'google-chrome-stable', # requires an entry under apt::sources in hiera
      'ldap-utils',
      'libldap2-dev',
      'libsasl2-dev',
      'libssl-dev',
      'libsystemd-dev',
      'policycoreutils',
      'python3-ldap',
    ]

    if 'mysql' in $superset_extras {
      # `mysqlclient` dependencies, cf. https://pypi.org/project/mysqlclient/
      # Omitting 'python3-dev' that clashed with later Python install
      $mysql_deps = ['default-libmysqlclient-dev', 'build-essential']
    } else {
      $mysql_deps = []
    }

    $os_dependencies = $base_deps + $mysql_deps

    ensure_resources(
      'package',
      $os_dependencies => {
        ensure  => present,
        require => Apt::Source['google-chrome'],
      }
    )
  }

  file { '/usr/bin/google-chrome':
    ensure  => 'link',
    target  => '/usr/bin/google-chrome-stable',
    require => Package[$os_dependencies],
  }

  exec { 'install chromedriver':
    command => join([
      'wget',
      'https://chromedriver.storage.googleapis.com/$(wget --no-check-certificate -qO -',
      "\"https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$(google-chrome --version | gawk 'match(\$0, /\s([0-9]*)\./, g) {print g[1]}')\")/chromedriver_linux64.zip",
      '&& unzip chromedriver_linux64.zip',
      '&& rm chromedriver_linux64.zip',
      '&& mv chromedriver /usr/local/bin',
    ], ' '),
    user    => 'root',
    group   => 'root',
    path    => '/usr/sbin:/usr/bin:/sbin:/bin',
    require => File['/usr/bin/google-chrome']
  }

  file { '/etc/conf.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root'
  }
}
