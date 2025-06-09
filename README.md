# Linux Kernel Training
The following notes describe the steps taken to complete the training homework assignment. 

### Kernel Information
The kernel used for this assignment was pulled from the [`FIPS-9`](https://github.com/ciq-rocky-fips/kernel/tree/FIPS-9) branch of the ciq-rocky-fips Linux kernel, version 5.14.0.

### Environment
The environment consists of a Docker container running a QEMU VM running the Rocky Linux kernel.

### Setup Steps
1. Launch the docker container with the `init.sh` script and enter the `/linux/kernel` directory.
2. Create kernel configuration file:
    1. Run `make mrproper` to clean everything (including any `.config` files)
    2. Start my making the minimal kernel config file with
```bash
make tinyconfig
```
    3. Edit config file by running
```bash
make menuconfig
```
        1. Enable the `64-bit kernel` option.
        2. Enable `TTY` under `Device drivers -> Character devices` submenu.
        3. Enable `support for printk` under the `General setup -> Configure standard kernel features` submenu.
        3. Enable `Initial RAM filesystem and RAM disk (initramfs/initrd) support)` in the `General setup` menu.
        5. Enable `Kernel support for ELF binaries` in `Executable file formats` submenu.
        6. Enable `sysfs file system support` in `Pseudo filesystems`.
        7. Enable `8250/16550 and compatible serial support` in `Device drivers -> Character devices -> Serial drivers` submenu and `Console on 8250/16550 and compatible serial port`.
        8. Enable `Module signature verification` under `Enable loadable module support` in the main menu.
        9. Enable `run-time self tests` in the `Cryptographic API` submenu. 
        10. Enable one of the DRBGs in `Cryptographic API -> NIST SP800-90A DRBG` submenu.
        11. Enable `FIPS 200 compliance` in the `Cryptographic API` submenu.
        12. Enable all the desired crypto algorithms you want to test in the `Cryptographic API` submenu.
        13. Save and exit.
3. Compile the kernel by running 
```bash
make ARCH=x86 -j$(nproc)
```
4. Set the modules install directory and install the modules
```bash
make INSTALL_MOD_PATH=tmp/modules modules_install
```
5. Move up a directory with `cd ..`
6. Download the pre-built Alpine initramfs:
```bash
wget https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.0-x86_64.tar.gz
```
7. Create directory for the initramfs and extract the Alpine tar ball
```bash
mkdir alpine-initramfs
```
```bash
cd alpine-initramfs
```
```bash
tar xzf ../alpine-minirootfs-3.19.0-x86_64.tar.gz
```
8. Create basic init file
```bash
cat > init << 'EOF'
#!/bin/sh
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev
echo "Kernel: $(uname -r)"
if [ -f /proc/sys/crypto/fips_enabled ]; then
    echo "FIPS: $(cat /proc/sys/crypto/fips_enabled)"
fi
exec /bin/sh
EOF
```
9. Make the init file executable
```bash
chmod +x init
```
10. Create the initramfs
```bash
find . | cpio -o -H newc | gzip > ../alpine-initramfs.cpio.gz
```
11. Move up a directory
```bash
cd ..
```
12. Boot the VM
```bash
qemu-system-x86_64 \
    -kernel kernel/arch/x86/boot/bzImage \
    -initrd alpine-initramfs.cpio.gz \
    -nographic \
    -append "console=ttyS0 debug earlyprintk fips=1" \
    -m 1G
```
