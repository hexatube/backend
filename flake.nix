{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let
      overlays = [ rust-overlay.overlays.default ];
      pkgs = import nixpkgs { system = "x86_64-linux"; inherit overlays; };
    in
    {
      devShell.x86_64-linux = pkgs.mkShell {
        buildInputs = with pkgs; [ 
          elixir 
          inotify-tools 
          postgresql_16 
          sqlite 
          (rust-bin.stable."1.78.0".default.override {
            extensions = [ "rust-src" ];
          })
          ffmpeg
          act
        ];
      };
    };
}
