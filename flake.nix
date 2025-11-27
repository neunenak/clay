{
  description = "Clay UI library with SDL2 examples";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Build SDL2 from source with PipeWire disabled
        sdl2 = pkgs.stdenv.mkDerivation {
          pname = "SDL2";
          version = "2.30.10";

          src = pkgs.fetchFromGitHub {
            owner = "libsdl-org";
            repo = "SDL";
            rev = "release-2.30.10";
            sha256 = "sha256-ogIHGcSg9ACrH62HM+sQFeB2o9gyUq/Vq7fKIy5jNL0=";
          };

          nativeBuildInputs = with pkgs; [ cmake ninja pkg-config ];
          buildInputs = with pkgs; [
            libGL
            mesa
            libpulseaudio
            alsa-lib
            wayland
            wayland-protocols
            wayland-scanner
            libxkbcommon
            libdecor
            dbus
            systemd
            libffi
            xorg.libX11
            xorg.libXext
            xorg.libXrandr
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXxf86vm
            xorg.libxcb
          ];

          cmakeFlags = [
            "-DSDL_SHARED=ON"
            "-DSDL_STATIC=ON"
            "-DSDL_PIPEWIRE=OFF"  # Disable PipeWire to avoid API incompatibility
            "-DSDL_WAYLAND=ON"
            "-DSDL_X11=ON"
          ];
        };

        # Build SDL2_ttf from source
        sdl2_ttf = pkgs.stdenv.mkDerivation {
          pname = "SDL2_ttf";
          version = "2.22.0";

          src = pkgs.fetchFromGitHub {
            owner = "libsdl-org";
            repo = "SDL_ttf";
            rev = "release-2.22.0";
            sha256 = "sha256-3NNyTVL9Xpj4QXsuIBcmKOVyindcftYXLbayWBu3c8A=";
          };

          nativeBuildInputs = with pkgs; [ cmake ninja pkg-config ];
          buildInputs = [ sdl2 pkgs.freetype pkgs.harfbuzz ];

          cmakeFlags = [
            "-DSDL2TTF_SHARED=ON"
            "-DSDL2TTF_STATIC=ON"
          ];
        };

        # Build SDL2_image from source
        sdl2_image = pkgs.stdenv.mkDerivation {
          pname = "SDL2_image";
          version = "2.8.4";

          src = pkgs.fetchFromGitHub {
            owner = "libsdl-org";
            repo = "SDL_image";
            rev = "release-2.8.4";
            sha256 = "sha256-1NR6EW8UWUBdA0pVfvBiIOe13NKD8dhoo3I0slZx3iQ=";
          };

          nativeBuildInputs = with pkgs; [ cmake ninja pkg-config ];
          buildInputs = [ sdl2 pkgs.libpng pkgs.libjpeg pkgs.libwebp ];

          cmakeFlags = [
            "-DSDL2IMAGE_SHARED=ON"
            "-DSDL2IMAGE_STATIC=ON"
          ];
        };

      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            sdl2
            sdl2_ttf
            sdl2_image
            pkgs.cmake
            pkgs.ninja
            pkgs.pkg-config
            pkgs.gcc
          ];

          shellHook = ''
            # Prioritize Nix-built SDL2 libraries over system libraries
            export PKG_CONFIG_PATH="${sdl2}/lib/pkgconfig:${sdl2_ttf}/lib/pkgconfig:${sdl2_image}/lib/pkgconfig"
            export LD_LIBRARY_PATH="${sdl2}/lib:${sdl2_ttf}/lib:${sdl2_image}/lib:${pkgs.wayland}/lib:${pkgs.libxkbcommon}/lib:${pkgs.libdecor}/lib:${pkgs.mesa}/lib:${pkgs.libGL}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
            export CMAKE_PREFIX_PATH="${sdl2}:${sdl2_ttf}:${sdl2_image}"

            # Ensure the Nix SDL2 libraries are found first
            export LIBRARY_PATH="${sdl2}/lib:${sdl2_ttf}/lib:${sdl2_image}/lib"

            echo "Clay SDL2 development environment loaded"
            echo "Using Nix-built SDL2 libraries with PipeWire disabled"
            echo "Run 'just build-sdl2' or 'cmake -B build -S . -DCLAY_INCLUDE_SDL2_EXAMPLES=ON && cmake --build build'"
          '';
        };

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "clay-sdl2-examples";
          version = "0.1.0";

          src = ./.;

          nativeBuildInputs = with pkgs; [ cmake ninja pkg-config ];
          buildInputs = [ sdl2 sdl2_ttf sdl2_image ];

          cmakeFlags = [
            "-DCLAY_INCLUDE_SDL2_EXAMPLES=ON"
            "-DCLAY_INCLUDE_ALL_EXAMPLES=OFF"
          ];

          installPhase = ''
            mkdir -p $out/bin
            cp examples/SDL2-video-demo/SDL2_video_demo $out/bin/
          '';
        };
      }
    );
}
