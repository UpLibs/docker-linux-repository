class upp_repository::install {
  package { $upp_repository::params::upp_repository_package_name:
    ensure => installed,
  }
}
