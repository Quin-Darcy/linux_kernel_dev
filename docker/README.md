# Linux Kernel Training
The following notes describe the steps taken to complete the training homework assignment. 

### Kernel Information
The kernel used for this assignment was pulled from the [`FIPS-9`](https://github.com/ciq-rocky-fips/kernel/tree/FIPS-9) branch of the ciq-rocky-fips Linux kernel, version 5.14.0.

### Environment
The environment consists of a Docker container running a QEMU VM running the Rocky Linux kernel.

### Setup Steps
1. Launch docker container and enter the directory containing the Rocky Linux kernel.
2. Create kernel configuration file:
    1. Run `make mrproper` to clean everything (including any `.config` files)
    2. Create new `.config` file based on default configuration `x86_64_defconfig` by running
```bash
make defconfig
```
    3. Edit config file by running
```bash
make menuconfig
```
        1. Enable `Module signature verification` under `Enable loadable module support` in the main menu.
        2. Enable `run-time self tests` in the `Cryptographic API` submenu. 
        3. Enable `FIPS 200 compliance` in the `Cryptographic API` submenu.
        4. Save and exit
3. Compile the kernel by running `make`.
4. 
