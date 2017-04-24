
class setup {

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  # include setup::java
  # include setup::docker
  # include setup::jenkins
  # include setup::elk
  # include setup::shipper  

}