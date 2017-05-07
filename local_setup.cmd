@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
choco install putty.install --force -y --allowEmptyChecksums
choco install virtualbox --force -y
choco install vagrant --force -y --allowEmptyChecksums
choco install packer --force -y
choco install awscli --force -y
choco install git.install --force -y