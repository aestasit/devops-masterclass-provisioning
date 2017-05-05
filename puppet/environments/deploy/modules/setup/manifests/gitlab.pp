
class setup::gitlab {

  class { 'gitlab':
    external_url => 'http://gitlab.extremeautmation.io',
  }

}