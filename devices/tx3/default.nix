{ config, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/base.nix")
    (modulesPath + "/installer/sd-card/sd-image.nix")
  ];

  sdImage = {
    populateFirmwareCommands = "";
    populateRootCommands = ''
      mkdir -p ./files/boot
      cp ${../emmc_autoscript} ./files/boot/emmc_autoscript
      cp ${../u-boot-tx3-qz.bin} ./files/boot/uboot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
    postBuildCommands =
      let
        bootloader = ../x96maxplus-u-boot.bin.sd.bin;
      in
      ''
        dd if=${bootloader} of=$img conv=fsync,notrunc bs=1 count=444
        dd if=${bootloader} of=$img conv=fsync,notrunc bs=512 skip=1 seek=1
      '';
  };
  image.baseName = "tx3";

  hardware.deviceTree = {
    enable = true;
    name = "meson-sm1-tx3-qz.dtb";
    dtbSource = ./dtbs;
  };

  systemd.network.networks.eth0 = {
    name = "eth0";

    address = [
      "10.0.0.10/24"
    ];
    routes = [
      {
        Gateway = "10.0.0.1";
        GatewayOnLink = true;
      }
    ];

  };
}
