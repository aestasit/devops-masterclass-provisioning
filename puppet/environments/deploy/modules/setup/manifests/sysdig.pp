
class setup::sysdig(

) {

  ensure_packages(["linux-headers-${::kernelrelease}"])

  apt::source { 'sysdig':
    location          => 'http://download.draios.com/stable/deb',
    release           => 'stable-$(ARCH)/',
    repos             => '',
    include           => {
      'src' => false
    },
    key               => {
      'id' => 'D27A72F32D867DF9300A241574490FD6EC51E8C4',
      'source' => 'https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public'
    }
  }

  package { 'sysdig':
    ensure  => latest,
    require => [
      Apt::Source['sysdig'],
      Package["linux-headers-${::kernelrelease}"],
    ]
  }

}