# minibook-support

NixOS module for https://github.com/petitstrawberry/minibook-support

## NixOS Configuration

```nix
{
  inputs = {
    nixpkgs.url = "<your nixpkgs version>";
    minibook-support = {
      url = "github:plopmenz/minibook-support";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      # Replace plopmenz with your desired configuration name
      nixosConfigurations.plopmenz = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          inputs.minibook-support.nixosModules.default
          {
            services.minibook-support.enable = true;
          }
          # The rest of your config
        ];
      };
    };
}
```
