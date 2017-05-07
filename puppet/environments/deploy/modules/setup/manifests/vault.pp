
class setup::vault(

) {

  class { '::vault':
    extra_config => {
      "listener" => {
        "tcp" => {
          "address" => "0.0.0.0:8200",
          "tls_disable" => 1
        }
      }
    }
  }

}