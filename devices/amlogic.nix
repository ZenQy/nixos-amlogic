{
  config,
  modulesPath,
  u-boot,
  bootloader,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/base.nix")
    (modulesPath + "/installer/sd-card/sd-image.nix")
  ];

  sdImage = {
    populateFirmwareCommands = ''
      cp ${./aml_autoscript} firmware/aml_autoscript
      cp ${u-boot} firmware/u-boot.bin
    '';
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
    postBuildCommands = ''
      dd if=${bootloader} of=$img conv=fsync,notrunc bs=1 count=444
      dd if=${bootloader} of=$img conv=fsync,notrunc bs=512 skip=1 seek=1
    '';
  };
  image.baseName = config.networking.hostName;

  systemd.network.networks.eth0 = {
    name = "eth0";
    address = [
      "10.0.0.10/24"
    ];
    gateway = [
      "10.0.0.1"
    ];
    DHCP = "ipv6";
  };
}
