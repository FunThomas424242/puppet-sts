
class grundsystem::params {
  case $::osfamily {
    'Debian': {
      case $::lsbdistcodename {
        'wheezy': {
        }
        'trusty': {
        }
      default: { fail("unsupported release ${::lsbdistcodename}") }
      }
    }
    default: { fail("unsupported platform ${::osfamily}") }
  }
}

class systemupdate {
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

  exec { 'apt-get update':
    command => 'apt-get update -y',
  }

  $sysPackages = [ 'build-essential' ]
  package { $sysPackages:
    ensure  => 'latest',
    require => Exec['apt-get update'],
  }
  
  $libsToInstall = ['wget','tar','gzip','zip']
  package { $libsToInstall:
    ensure  => 'latest',
    require => Exec['apt-get update']
  }
}