
class setup::python {

  class { 'python' :
    version    => 'system',
    pip        => 'latest',
  }

  python::pip { 'fabric':
    pkgname       => 'fabric',
    ensure        => 'latest',
  }

}