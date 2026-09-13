{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];

  # 3. 自定义 SD 卡镜像行为
  sdImage = {
    populateFirmwareCommands = "";
  };
  image.fileName = "nixos-phicomm-n1.img";

  hardware.deviceTree = {
    enable = true;
    name = "amlogic/meson-gxl-s905d-phicomm-n1.dtb";
    filter = "*phicomm*.dtb";
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
