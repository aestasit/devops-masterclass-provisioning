
class setup::common(

) {

  package { [
    "zip",
    "curl",
    "wget",
    "build-essential",
    "tree",
    "links",
    "mc",
    "sysstat",
    "nmap",
    "whois"
  ]:
    ensure => latest
  }

}
