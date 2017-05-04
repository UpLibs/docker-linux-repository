class upp_repository::params {
  case $::operatingsystem {
    /^(RedHat|CentOS|Debian|Ubuntu)$/: {
      $upp_repository_package_name 		= 'wget'
      $upp_repository_dir	 		= '/var/cache/repository'
      $upp_repository_script	 		= '/usr/sbin/upp-snapshot-control.sh'
      $upp_repository_arch      = '/usr/sbin/upp-arch.sh'
      $upp_repository_bats      = '/usr/sbin/upp-bats.sh'
      $upp_repository_functions      = '/usr/sbin/upp-functions.sh'
      $upp_repository_shellinabox      = '/usr/sbin/upp-shellinabox.sh'
      $upp_repository_uboot_udoo      = '/usr/sbin/upp-uboot-udoo.sh'
      $upp_repository_variables      = '/usr/sbin/upp-variables.sh'
      $upp_repository_download_packages      = '/usr/sbin/upp-download-packages.sh'
      $upp_repository_rename_static_files      = '/usr/sbin/upp-rename-static-files.sh'
      $upp_repository_cron			= 'repository_archlinux'
      $upp_repository_minute_cron		= '0'
      $upp_repository_hour_cron	 		= '0-23/3'
      $upp_repository_supervisor		= '/etc/supervisor.conf.d/crond.conf'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}

