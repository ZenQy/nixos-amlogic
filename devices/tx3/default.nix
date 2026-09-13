{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];

  # 3. 自定义 SD 卡镜像行为
  sdImage = {
    populateFirmwareCommands = "";
    postBuildCommands = ''
      echo '----------'
      ls
      cd $out
      echo '----------'
      ls
      echo '----------'
      ls $img
      dd if=${./u-boot.bin} of=$img conv=fsync,notrunc bs=1 count=444
      dd if=${./u-boot.bin} of=$img conv=fsync,notrunc bs=512 skip=1 seek=1
    '';
  };
  image.baseName = "phicomm-n1";

  hardware.deviceTree = {
    enable = true;
    name = "amlogic/meson-sm1-x96-air-gbit.dtb";
    filter = "*x96*.dtb";
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
