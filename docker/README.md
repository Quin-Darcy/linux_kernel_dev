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
        4. Enable `Module signature verification` under `Enable loadable module support` in the main menu.
        5. Enable `run-time self tests` in the `Cryptographic API` submenu. 
        6. Enable one of the DRBGs in `Cryptographic API -> NIST SP800-90A DRBG` submenu.
        7. Enable `FIPS 200 compliance` in the `Cryptographic API` submenu.
        8. Enable all the desired crypto algorithms you want to test in the `Cryptographic API` submenu.
        9. Save and exit.
3. Compile the kernel by running 
```bash
make ARCH=x86 -j$(nproc)
```
4. Set the modules install directory and install the modules
```bash
make INSTALL_MOD_PATH=tmp/modules modules_install
```
