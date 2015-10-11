# Class: sts::params
#
# Klasse zur Vorbelegung der Parameter für das sts Modul
#
class sts::params (
  $pVersion        = '3.7.1',
  $pEclipseRelease = '4.5',
  $pEclipseVersion = '4.5.1',
  $pFlavor         = $::architecture ? {
    'amd64' => '-x86_64',
    default => ''
  },
  $pInstall    = '/opt',
 )
 {
    $pTarball = "/tmp/sts-${pVersion}.tar.gz"
    $pUrl = "http://dist.springsource.com/release/STS/${pVersion}.RELEASE/dist/e${pEclipseRelease}/spring-tool-suite-${pVersion}.RELEASE-e${pEclipseVersion}-linux-gtk${pFlavor}.tar.gz"
    $pHome = "${pInstall}/sts-bundle/sts-${pVersion}.RELEASE"
    $pSymlink = "${pInstall}/sts"
    $pExecutable = "${pSymlink}/STS"
  }
  
