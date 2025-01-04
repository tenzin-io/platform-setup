# README
This workspace contains an Ansible playbook that helps build a custom Ubuntu installation ISO for autoinstall.  The ISO can then be copied onto a USB and used for baremetal automated installation of Ubuntu Server.

# Major issue
- This custom ISO doesn't boot on UEFI-only systems.  In particular, Asrock B650 motherboard.  It works fine on a Asrock B550 motherboard.

## Usage
- Install pip `requirements.txt`
- Setup environment variables for defaults (if needed).
  - `AUTOMATION_SSH_PUBKEY`, `CONSOLE_USERNAME`, `CONSOLE_PASSWORD`
- Run `ansible-playbook main.yaml`

## Helpful documentation
- <https://help.ubuntu.com/community/LiveCDCustomization>

### Xorriso command
```
$ xorriso -indev downloads/ubuntu-24.04.1-live-server-amd64.iso -report_el_torito cmd
xorriso 1.5.2 : RockRidge filesystem manipulator, libburnia project.

xorriso : NOTE : Loading ISO image tree from LBA 0
xorriso : UPDATE :    1065 nodes read in 1 seconds
libisofs: NOTE : Found hidden El-Torito image for EFI.
libisofs: NOTE : EFI image start and size: 1351729 * 2048 , 10144 * 512
xorriso : NOTE : Detected El-Torito boot information which currently is set to be discarded
Drive current: -indev 'downloads/ubuntu-24.04.1-live-server-amd64.iso'
Media current: stdio file, overwriteable
Media status : is written , is appendable
Boot record  : El Torito , MBR protective-msdos-label grub2-mbr cyl-align-off GPT
Media summary: 1 session, 1354431 data blocks, 2645m data,  291g free
Volume id    : 'Ubuntu-Server 24.04.1 LTS amd64'
-volid 'Ubuntu-Server 24.04.1 LTS amd64'
-volume_date uuid '2024082715393700'
-boot_image grub grub2_mbr=--interval:imported_iso:0s-15s:zero_mbrpt,zero_gpt:'downloads/ubuntu-24.04.1-live-server-amd64.iso'
-boot_image any partition_table=on
-boot_image any partition_cyl_align=off
-boot_image any partition_offset=16
-boot_image any mbr_force_bootable=on
-append_partition 2 28732ac11ff8d211ba4b00a0c93ec93b --interval:imported_iso:5406916d-5417059d::'downloads/ubuntu-24.04.1-live-server-amd64.iso'
-boot_image any part_like_isohybrid=on
-boot_image any iso_mbr_part_type=a2a0d0ebe5b9334487c068b6b72699c7
-boot_image any cat_path='/boot.catalog'
-boot_image grub bin_path='/boot/grub/i386-pc/eltorito.img'
-boot_image any platform_id=0x00
-boot_image any emul_type=no_emulation
-boot_image any load_size=2048
-boot_image any boot_info_table=on
-boot_image grub grub2_boot_info=on
-boot_image any next
-boot_image any efi_path='--interval:appended_partition_2_start_1351729s_size_10144d:all::'
-boot_image any platform_id=0xef
-boot_image any emul_type=no_emulation
-boot_image any load_size=5193728
-boot_image isolinux partition_entry=gpt_basdat
```

### Extracting the mbr.img
```
$ sudo dd bs=1 count=446 if=downloads/ubuntu-24.04.1-live-server-amd64.iso of=tmp/mbr.img
```

### Extracting the EFI.img
```
$ fdisk -l downloads/ubuntu-24.04.1-live-server-amd64.iso 
Disk downloads/ubuntu-24.04.1-live-server-amd64.iso: 2.58 GiB, 2773874688 bytes, 5417724 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: E51A2C4E-9040-4443-A5F4-7FCAC8FA7E5C

Device                                            Start     End Sectors  Size Type
downloads/ubuntu-24.04.1-live-server-amd64.iso1      64 5406915 5406852  2.6G Microsoft basic data
downloads/ubuntu-24.04.1-live-server-amd64.iso2 5406916 5417059   10144    5M EFI System
downloads/ubuntu-24.04.1-live-server-amd64.iso3 5417060 5417659     600  300K Microsoft basic data

$ sudo dd bs=512 count=10144 skip=5406916 if=downloads/ubuntu-24.04.1-live-server-amd64.iso of=tmp/EFI.img
```
