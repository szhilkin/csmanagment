#set -x

usage() {
  echo "Usage:"
  echo "  `basename $0`: <hypervisor>"
  echo "  `basename $0`: {xenserver, kvm, vmware, lxc, ovm}"
  exit 2
}

[ $# -lt 1 ] && usage


HYPERVISOR=$1

INSTALL_SYS_TMPLT=/usr/share/cloudstack-common/scripts/storage/secondary/cloud-install-sys-tmplt
EXPORT_PATH=/exports/secondary

if [ ! -d ${EXPORT_PATH} ]; then
	echo "ERROR: Secondary Storage path '${EXPORT_PATH}' not found."
	exit 3
fi

URL="http://download.cloudstack.org/systemvm/4.11"
case $HYPERVISOR in
 	kvm)
		TO_DOWNLOAD=${URL}/systemvm64template-master-4.11.1-kvm.qcow2.bz2
		;;
	xenserver)
		TO_DOWNLOAD=${URL}/systemvm64template-master-4.11.1-xen.vhd.bz2
		;;
	vmware)
		TO_DOWNLOAD=${URL}/systemvm64template-master-4.11.1-vmware.ova
		;;
	lxc)
		TO_DOWNLOAD=${URL}/systemvm64template-master-4.11.1-kvm.qcow2.bz2
		;;
	ovm)
		TO_DOWNLOAD=${URL}/systemvm64template-master-4.11.1-ovm.raw.bz2
		;;
	*)
		echo "ERROR: hypervisor not found"
		exit 4
		;;
esac

${INSTALL_SYS_TMPLT} -m ${EXPORT_PATH} -u ${TO_DOWNLOAD} -h $HYPERVISOR

exit 0
