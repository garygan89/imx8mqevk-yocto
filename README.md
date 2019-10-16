Run `setup_yocto_build -b <yocto_release> <manifest_xml_file>` to initialize a complete bitbake yocto build env for a particular Yocto Release.

E.g.
```
./setup_build.sh -b sumo -f imx-4.14.98-2.0.0_ga-virt.xml
```

Currently supported yocto release:
- sumo

Currently supported kernel:
- `imx-4.14.98-2.0.0_ga-virt`: Support `meta-virtualization`.
- `imx-4.14.98-2.0.0_ga-virt-optee`: Support `meta-virtualization` and `meta-optee`.

Other scripts to setup the system is at `extras` for networking, package manager, etc.