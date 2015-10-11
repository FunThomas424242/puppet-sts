
#
# Class: sts
#
# This module manages SpringSource Tool Suite
#
class sts {
  
  include params
  
  $sts_version      = $sts::params::pVersion
  $eclipse_release  = $sts::params::pEclipseRelease
  $eclipse_version  = $sts::params::pEclipseVersion
  $sts_tarball      = $sts::params::pTarball
  $flavor           = $sts::params::pFlavor
  $sts_install      = $sts::params::pInstall
  $sts_home         = $sts::params::pHome
  $sts_url          = $sts::params::pUrl
  $sts_symlink      = $sts::params::pSymlink
  $sts_executable   = $sts::params::pExecutable


  notice("sts_version: ${sts_version}")
  notice("eclipse_release: ${eclipse_release}")
  notice("eclipse_version: ${eclipse_version}")
  notice("sts_tarball: ${sts_tarball}")
  notice("flavor: ${flavor}")
  notice("sts_install: ${sts_install}")
  notice("sts_home: ${sts_home}")
  notice("sts_url: ${sts_url}")
  notice("sts_symlink: ${sts_symlink}")
  notice("sts_executable: ${sts_executable}")

  include systemupdate

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

  file { '/usr/share/icons/sts.xpm' :
    ensure  => link,
    target  => "${sts_home}/icon.xpm",
    require => File[$sts_home],
  }

  file { '/usr/share/applications/sts.desktop' :
    require => File[$sts_symlink],
    content => template('sts/sts.desktop.erb'),
  }
  
}
