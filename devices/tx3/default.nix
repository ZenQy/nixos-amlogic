{ config, modulesPath, ... }:

let
  amlogic = import ../amlogic.nix {
    inherit config modulesPath;
    u-boot = ../u-boot-tx3-qz.bin;
    bootloader = ../x96maxplus-u-boot.bin.sd.bin;
  };
in

{
  hardware.deviceTree = {
    enable = true;
    name = "meson-sm1-tx3-qz.dtb";
    dtbSource = ../dtbs;
  };
}
// amlogic
