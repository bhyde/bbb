# Local Variables:
# mode: shell-script
# eval: (sh-set-shell "bash")
# End:

function LOG(){ echo "LOG: $*" ; }

function run-safe(){
    trap 'LOG "leaving $(basename $0)"' EXIT
    set -o nounset -o errexit -o verbose
}

function assure-extra-opkg-repo(){
  R=http://feeds.angstrom-distribution.org/feeds/unstable/ipk/glibc/armv7a/base
  if grep --silent "$R" /etc/opkg/angstrom-base.conf ; then return 0 ; fi
  echo "src/gz angstrom-base $R" >> /etc/opkg/angstrom-base.conf
  opkg update
}

function install-this(){
  V=$2
  U="$1/$V.tar.gz"
  echo "LOG: installing $V"
  curl --remote-name --location --insecure "$U"
  tar xzf "$V.tar.gz"
  rm "$V.tar.gz"
  cd "$V"
  ./configure $3
  make $4 install
  cd ..
  rm -rf "$V"
}
