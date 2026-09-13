{
  description = "NixOS image of Amlogic Devices";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      inherit (builtins)
        filter
        attrNames
        readDir
        listToAttrs
        ;
      floder =
        dir:
        let
          files = readDir dir;
        in
        filter (name: files.${name} == "directory") (attrNames files);

    in
    {
      nixosConfigurations = listToAttrs (
        map (host: {
          name = host;
          value = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              ./configuration.nix
              ./devices/${host}
            ];
          };
        }) (floder ./devices)
      );

      packages.aarch64-linux = listToAttrs (
        map (host: {
          name = host;
          value = self.nixosConfigurations.${host}.config.system.build.sdImage;
        }) (floder ./devices)
      );
    };
}
