{ ... }:
let
  amlogic = import ../amlogic.nix {
    u-boot = ../u-boot-x96maxplus.bin;
    bootloader = ../x96maxplus-u-boot.bin.sd.bin;
  };
in
{
  hardware.deviceTree = {
    enable = true;
    name = "meson-sm1-x96-max-plus.dtb";
    dtbSource = ../dtbs;
  };
}
// amlogic
