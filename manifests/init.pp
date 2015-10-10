# Class: sts
#
# This module manages SpringSource Tool Suite
#
class sts {
  $sts_version = '3.7.1'
  $eclipse_release = '4.5'
  $eclipse_version = "${eclipse_release}.1"
  $sts_tarball = "/tmp/sts-${sts_version}.tar.gz"
  $flavor = $::architecture ? {
    'amd64' => '-x86_64',
    default => ''
  }
  $sts_install = '/opt'
  $sts_home = "${sts_install}/sts-bundle/sts-${sts_version}.RELEASE"
  $sts_url = "http://dist.springsource.com/release/STS/${sts_version}.RELEASE/dist/e${eclipse_release}/spring-tool-suite-${sts_version}.RELEASE-e${eclipse_version}-linux-gtk${flavor}.tar.gz"
  $sts_symlink = "${sts_install}/sts"
  $sts_executable = "${sts_symlink}/STS"

### system programs

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

class grundsystem::params {
  case $::osfamily {
    "Debian": {
      case $::lsbdistcodename {
        "wheezy": {
        }
        "trusty": {
        }
      default: { fail("unsupported release ${::lsbdistcodename}") }
      }
    }
    default: { fail("unsupported platform ${::osfamily}") }
  }
}

class systemupdate {

  exec { 'apt-get update':
    command => 'apt-get update -y',
  }

  $sysPackages = [ "build-essential" ]
  package { $sysPackages:
    ensure => "latest",
    require => Exec['apt-get update'],
  }
  
  $libsToInstall = ["wget","tar","gzip","zip"]
  package { $libsToInstall:
    ensure => "latest",
    require => Exec['apt-get update']
  }
}

include systemupdate

## logic



  exec { 'download-sts':
    command => "/usr/bin/wget -O ${sts_tarball} ${sts_url}",
    require => Package['wget'],
    creates => $sts_tarball,
    timeout => 1200,
  }

  file { $sts_tarball :
    ensure  => file,
    require => Exec['download-sts'],
  }

  exec { 'install-sts' :
    require => File[$sts_tarball],
    cwd     => $sts_install,
    command => "/bin/tar -xa -f ${sts_tarball}",
    creates => $sts_home,
  }

  file { $sts_home :
    ensure  => directory,
    require => Exec['install-sts'],
  }

  file { $sts_symlink :
    ensure  => link,
    target  => $sts_home,
    require => File[$sts_home],
  }

  file { '/usr/share/icons/sts.xpm':
    ensure  => link,
    target  => "${sts_home}/icon.xpm",
    require => File[$sts_home],
  }

  file { '/usr/share/applications/sts.desktop' :
    require => File[$sts_symlink],
    content => template('sts/sts.desktop.erb'),
  }


}
