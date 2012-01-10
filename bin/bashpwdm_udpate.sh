#!/bin/bash

#################################################################
# @Author:    Paolo Stivanin aka Polslinux
# @Name:      Bash PWD Manager Update Script      
# @Copyright: 2011
# @Site:      http://projects.polslinux.it
# @License:   GNU AGPL v3 http://www.gnu.org/licenses/agpl.html 
#################################################################

distro=$(cat /etc/issue | cut -d' ' -f1 -s)
last_version=$(cd /tmp && wget --no-check-certificate https://raw.github.com/polslinux/BashPWDManager/master/docs/version &>/dev/null && cat version | grep -Eo '[0-9\.]+')

function update_bashpwdm(){
if [ $(id -u) != "0" ]; then 
  echo "  * ERROR: please run update script as ROOT!\n"
  exit 1
fi
echo "  * Write your exact username:"
read username
echo "  * Checking Bash PWD Manager version..."
echo "    Your version is $version
    Newest version is $last_version"
if [ "$version" != "$last_version" ] ; then
  echo "  * Updating Bash PWD Manager, please wait..."
  cd /tmp && mkdir bashpwdm_tmp
  cd bashpwdm_tmp && wget https://github.com/downloads/polslinux/BashPWDManager/bashpwdm_v$last_version.tar.bz2 &>/dev/null
  tar -xjf bashpwdm_v$last_version.tar.bz2
  cp LICENSE uninstall docs/* /usr/share/doc/bash-pwd-manager
  cp bin/bashpwdm.sh /usr/local/bin
  cp bin/bashpwdm-config.sh /usr/local/bin
  cp bin/bashpwdm_udpate.sh /usr/local/bin
  chown $username /usr/local/bin/bashpwdm
  chown $username /usr/local/bin/bashpwdm-config
  chown $username /usr/local/bin/bashpwdm_update
  chmod +x /usr/local/bin/bashpwdm
  chmod +x /usr/local/bin/bashpwdm-config
  chmod +x /usr/local/bin/bashpwdm_update
  cd .. && rm -r bashpwdm_tmp && rm -f bashpwdm_v$last_version.tar.bz2
  echo "  * All done, Bash PWD Manager has been updated :)"
elif [ "$version" = "$last_version" ] ; then
  echo "  * Bash PWD Manager is already up-to-date"
fi
}

update_bashpwdm
if [ -f /tmp/version ] ;then
 rm -f /tmp/version
fi
exit 0