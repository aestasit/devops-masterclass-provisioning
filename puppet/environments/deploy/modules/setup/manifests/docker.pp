
class setup::docker {

  class { '::docker':
    use_upstream_package_source => false
  }

}