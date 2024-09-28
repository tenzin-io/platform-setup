# cat create_vm.sh
IMAGE=/cloud-images/noble-server-cloudimg-amd64.img
VM_FOLDER=/var/lib/libvirt/machines
VM_NAME=$1
DIR_NAME=$(dirname $0)

if [[ -z $VM_NAME ]]
then
	echo Usage: $0 [ vm name ]
	exit 1
fi

if [[ ! -e $IMAGE ]]
then
	echo Error: /cloud-images/noble-server-cloudimg-amd64.img does not exist
	exit 1
fi

mkdir -p $VM_FOLDER
cp $IMAGE ${VM_FOLDER}/${VM_NAME}

cd ${DIR_NAME}/${VM_NAME}
genisoimage -output seed.iso -volid cidata -joliet -rock user-data meta-data && cp seed.iso ${VM_FOLDER}/${VM_NAME}-seed.iso
cd ${DIR_NAME}

qemu-img resize -f qcow2 ${VM_FOLDER}/${VM_NAME} +1200G

sudo virt-install \
--virt-type kvm \
--features kvm_hidden=on \
--name $VM_NAME \
--os-variant ubuntu24.04 \
--cpu host-passthrough \
--ram 118784 \
--vcpus 7 \
--disk path=${VM_FOLDER}/${VM_NAME},format=raw \
--disk path=${VM_FOLDER}/${VM_NAME}-seed.iso,device=cdrom \
--graphics none \
--console pty,target_type=serial \
--import \
--network network=vm-network,model=virtio \
--noautoconsole
