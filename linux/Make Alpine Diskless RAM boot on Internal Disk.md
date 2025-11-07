# Alpine Diskless on Internal Hard Drive
### Quick Steps
**Note this will wipe a drive**
```
ip link set eth0 up
udhcpc -i eth0
echo "nameserver 1.1.1.1" > /etc/resolv.conf
# setup-apkrepos -l
echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main" > /etc/apk/repositories
echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories
apk update
apk add wipefs util-linux
lsblk
```
Confirm the hard disk.  Usually /dev/sda if SCSI or /dev/vda if KVM VirtIO.
```
wipefs --all /dev/sda # DANGER!!!
fdisk /dev/sda
# n,p,1,<enter>,<enter>,t,c,a,w
mkfs.vfat /dev/sda1
setup-bootable /media/cdrom /dev/sda1
```
Reboot from hard disk, run `setup-alpine`, then `lbu ci`.  Choose "none" for the disk and the partition to save config.

When in Fdisk, can enter "+2G" to make a 2GB partition, or some other size.
# Description from reddit (modified)
yeah, I just did it like a few minutes before I replied. You've just fallen victim to alpine's wonky as hell documentation.

so, here's what you do to make that work. it's just like making a diskless usb. It looks like a lot of steps, but it's really not. It only really takes a few minutes once you've done it and similar a few times.

* Boot from the install media (I'm assuming you made it by dd an iso image or similar). That should get you to a vanilla standard alpine running from ram with no config (login as root/no-password and the hostname will say localhost).

* once booted, run `setup-alpine` and just go through it until you get networking and the apk repository stuff. Once you get past the apk setup, you can ctrl-C. None of this will get saved.

* `apk add wipefs util-linux` (this will get you some tools to make sure your disk doesn't have weird stuff that screws you)

* run `lsblk` to figure out what the disk you wanna turn into your diskless boot. let's say it's /dev/sda for this example, change as needed.

* `wipefs --all /dev/sda` <- this will nuke EVERYTHING on that disk, including weird MBR crap or boot loader shenanigans that might be floating around. It will also kill all the data on the disk so...you might wanna practice this on a garbage system VM if you're fiddling with a machine that has stuff you don't wanna lose.

* `fdisk /dev/sda` and create a primary partition that will hold your diskless stuff. the keys I use to do so are:
```
n,p,1,<enter>,<enter>,t,c,a,w
```
* That will make a big sda1 partition that takes up the whole device, set the type to win95 fat, and set the bootable flag on it. Alter as you need.

* `mkfs.vfat /dev/sda1`

* Figure out where your install media files are mounted. if you run a `df`, you should see a read only mount for something like `/media/cdrom` or `/media/usb` or something else, depending on your environment. Let's use `/media/cdrom` for an example

* `setup-bootable /media/cdrom /dev/sda1` #obviously change the paths to fit what your machine is spitting out.

After that's done, you should be able to pull your boot media and reboot the system and it will go off the drive. 
* Login as root and run `setup-alpine`.  This time, these settings will stick. 
* When it gets to the part where it asks you to pick what disk you want, **select none**. 
* It will then ask something about storing configs. one of those options should be the disk you booted from (it would be 'sda1' in the above example). **pick that one**. 
* Then it'll ask you where to store your cache, you should be storing in something like /media/sda1/cache . 
* **When you're done, don't forget to run** `lbu ci` **to commit those changes to disk.** you can test/verify it did the thing correct by rebooting and seeing it preserve your alpine setup.

Source: [https://old.reddit.com/r/AlpineLinux/comments/1bezynm/diskless_install_to_disk/kuxcy70/]