# =Class superset::db
class superset::db inherits superset {
  include redis
  include postgresql::lib::devel
  include postgresql::lib::python

  if $manage_database and ($db_host == 'localhost' or $db_host =~ /^127\./) {
    include postgresql::server

    postgresql::server::db { $db_name:
      user     => $db_user,
      password => postgresql_password($db_user, $db_pass),
    }

    if defined('pgdump::dump') {
      class { 'pgdump::dump':
        db_name     => $db_name,
        db_dump_dir => '/var/lib/pgsql/dump',
        require     => Postgresql::Server::Db[$db_name]
      }
    }
  }
}
