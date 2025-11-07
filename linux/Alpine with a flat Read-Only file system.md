# Alpine with a flat Read-Only file system (but not Diskless mode - saves RAM)
Replicating the read-only OpenBSD root isn't officially supported by Alpine, but uses significantly less RAM than running Alpine Diskless off the disk.  The disk image also compresses better, asdiskless uses a bunch of compressed apk packages.

Make a place to put everything, add tmpfs to /etc/fstab, and add a script to make the rw directories in Tmpfs.

TODO: resov.conf needs to be writable.

```
# config scripts
echo "#!/bin/sh" > /usr/bin/mount-rw.sh
echo "mount -o remount,rw /" >> /usr/bin/mount-rw.sh
echo "#!/bin/sh" > /usr/bin/mount-ro.sh
echo "mount -o remount,ro /" >> /usr/bin/mount-ro.sh
# /usr/bin/update-var.sh
cat > /usr/bin/update-var.sh <<'EOF'
#!/bin/sh
# copy running /var to /cfg/var
mount -o remount,rw /
cp -Rp /var/ /cfg/
# cp -Rp /var/{db,cron,spool,mail,run,www} /cfg/var/
mount -o remount,ro /
EOF
chmod +x /usr/bin/mount-rw.sh
chmod +x /usr/bin/mount-ro.sh
chmod +x /usr/bin/update-var.sh 

# actually set up
mkdir -p /cfg/
cp -Rp /var /cfg/
cp -Rp /dev /cfg/
echo "tmpfs   /var    tmpfs   rw,mode=755,size=30m    0 0" >> /etc/fstab
# echo "tmpfs   /tmp    tmpfs   rw,mode=1777,size=12m   0 0" >> /etc/fstab
echo "tmpfs   /run    tmpfs   rw,mode=755             0 0" >> /etc/fstab
echo "#!/bin/sh" > /etc/local.d/00-rw_dirs.start
echo "cp -a /cfg/dev/* /dev/" >> /etc/local.d/00-rw_dirs.start
echo "cp -a /cfg/var/* /var/" >> /etc/local.d/00-rw_dirs.start
chmod +x /etc/local.d/00-rw_dirs.start
rc-update add local default

```
Optionally /dev — but Alpine udev / mdev expects a real /dev, use tmpfs only if you copy a base dev tree on boot:
```
tmpfs   /dev    tmpfs   rw,mode=755,size=8m     0 0
```
If a desktop will be used, adding a tmpfs to `/etc/fstab` for the user caches is useful, and setting up home directories in tmpfs helps
```
# echo "tmpfs /home/*/.cache    tmpfs   size=32m,nodev,nosuid  0 0" >> /etc/fstab
echo "tmpfs /home    tmpfs   size=48m,nodev,nosuid  0 0" >> /etc/fstab
mkdir -p /cfg/home
mkdir -p /cfg/home/user
chown user /cfg/home/user
echo "cp -a /cfg/home/* /home/" >> /etc/local.d/00-rw_dirs.start
```
TODO: possibly add scripts to sync the home directories.

Additionally, 
Alpine Specific Notes:
* Use `lbu commit` instead of manually copying `/etc` files
* `/etc/resolv.conf` is static by default; do not use resolvd like OpenBSD
* `/var/lib/apk` must survive or apk breaks → keep it in lbu config or bind-mount a small persistent dir
Make persist apk:
```
mkdir -p /persist/apk
mount --bind /persist/apk /var/cache/apk
```

How to make / rw:
```
mount -o remount,rw /
# do something
mount -o remount,ro /
```
