class upp_repository::post {

file { $upp_repository::params::upp_repository_dir:
        ensure  => directory,
        mode    => '0755',
        require => Class[upp_repository::install],
}

file { $upp_repository::params::upp_repository_script:
        ensure  => present,
        mode    => '0755',
	source =>  "puppet:///modules/upp_repository/upp-snapshot-control.sh",
        require => File[$upp_repository::params::upp_repository_dir],
}



cron { $upp_repository::params::upp_repository_cron:
	command  => $upp_repository::params::upp_repository_script,
	user     => root,
	hour     => $upp_repository::params::upp_repository_hour_cron,
	minute  => $upp_repository::params::upp_repository_minute_cron,
        #require => File[$upp_repository::params::upp_repository_supervisor],
        require => File[$upp_repository::params::upp_repository_script],
}

}
