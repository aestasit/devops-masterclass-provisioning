

class setup::java {

  file { "/usr/lib/jvm":
    ensure              => directory
  }

  archive { "/tmp/jdk-8u111-linux-x64.tar.gz":
    ensure       => present,
    source       => "http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.tar.gz",
    cookie       => 'gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie',
    extract_path => '/usr/lib/jvm',
    extract      => true,
    cleanup      => true,
    creates      => '/usr/lib/jvm/jdk1.8.0_111'
  }

  file { "/usr/bin/java":
    ensure       => link,
    target       => '/usr/lib/jvm/jdk1.8.0_111/bin/java',
    require      => Archive["/tmp/jdk-8u111-linux-x64.tar.gz"]
  }

  file { "/usr/bin/javac":
    ensure       => link,
    target       => '/usr/lib/jvm/jdk1.8.0_111/bin/javac',
    require      => Archive["/tmp/jdk-8u111-linux-x64.tar.gz"]
  }

  file { "/usr/bin/javadoc":
    ensure       => link,
    target       => '/usr/lib/jvm/jdk1.8.0_111/bin/javadoc',
    require      => Archive["/tmp/jdk-8u111-linux-x64.tar.gz"]
  }

}