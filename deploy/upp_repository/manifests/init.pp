class upp_repository (
) {

  class { 'upp_repository::params': }
  class { 'upp_repository::install': }
  class { 'upp_repository::post': }

  Class['upp_repository::params'] ->
  Class['upp_repository::install'] ->
  Class['upp_repository::post']

}
