# == Class fdio::install
#
# Manages the installation of fdio.
#
class fdio::install {

  if !empty($fdio::repo_branch) and $fdio::repo_branch != 'none' {
    $base_url = $fdio::repo_branch ? {
      'release' => 'https://nexus.fd.io/content/repositories/fd.io.centos7/',
      'master'  => 'https://nexus.fd.io/content/repositories/fd.io.master.centos7/',
      default   => "https://nexus.fd.io/content/repositories/fd.io.${fdio::repo_branch}.centos7/",
    }

    # Add fdio's Yum repository
    yumrepo { "fdio-${fdio::repo_branch}":
      baseurl  => $base_url,
      descr    => "FD.io ${fdio::repo_branch} packages",
      enabled  => 1,
      gpgcheck => 0,
      notify   => Package['vpp'],
    }
  }

  # Install the VPP RPM
  package { 'vpp':
    ensure => present,
  }


  if $fdio::vpp_dpdk_support {
    package { 'vpp-plugins':
      ensure  => present,
      require => Package['vpp'],
    }
  }
}
