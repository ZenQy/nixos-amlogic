{ config, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/base.nix")
    (modulesPath + "/installer/sd-card/sd-image.nix")
  ];

  # 3. 自定义 SD 卡镜像行为
  sdImage = {
    populateFirmwareCommands = "";
    populateRootCommands = ''
      mkdir -p ./files/boot
      cp ${./emmc_autoscript} ${./uboot} ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
    postBuildCommands = ''
      dd if=${./uboot} of=$img conv=fsync,notrunc bs=1 count=444
      dd if=${./uboot} of=$img conv=fsync,notrunc bs=512 skip=1 seek=1
    '';
  };
  image.baseName = "tx3";

  hardware.deviceTree = {
    enable = true;
    name = "amlogic/meson-sm1-x96-air-gbit.dtb";
    filter = "*x96-air*.dtb";
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
