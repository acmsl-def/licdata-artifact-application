# flake.nix
#
# This file packages licdata-artifact-application as a Nix flake.
#
# Copyright (C) 2024-today acm-sl/licdata-artifact-application
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
{
  description = "Nix flake for acmsl/licdata-artifact-application";
  inputs = rec {
    acmsl-licdata-artifact-domain = {
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:acmsl-def/licdata-artifact-domain/0.0.12";
    };
    acmsl-licdata-artifact-events = {
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:acmsl-def/licdata-artifact-events/0.0.11";
    };
    acmsl-licdata-artifact-infrastructure = {
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:acmsl-def/licdata-artifact-infrastructure/0.0.6";
    };
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixos.url = "github:NixOS/nixpkgs/24.05";
    pythoneda-shared-pythonlang-banner = {
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      url = "github:pythoneda-shared-pythonlang-def/banner/0.0.71";
    };
    pythoneda-shared-pythonlang-domain = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      url = "github:pythoneda-shared-pythonlang-def/domain/0.0.92";
    };
    pythoneda-shared-pythonlang-application = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-pythonlang-def/application/0.0.90";
    };
    pythoneda-shared-pythonlang-artf-application = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-pythonlang-artf-def/application/0.0.44";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        org = "acmsl";
        repo = "licdata-artifact-application";
        version = "0.0.1";
        sha256 = "1pf056125irapidvk43yv7vywfl5a95wnv9i7bnqs1mmhxjnxjmp";
        pname = "${org}-${repo}";
        pythonpackage = "org.acmsl.artifact.licdata.application";
        package = builtins.replaceStrings [ "." ] [ "/" ] pythonpackage;
        pkgs = import nixos { inherit system; };
        description = "Licdata Artifact Application";
        entrypoint = "licdata_artifact_app";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/${org}/${repo}";
        maintainers = [ "rydnr <github@acm-sl.org>" ];
        archRole = "B";
        space = "A";
        layer = "D";
        nixosVersion = builtins.readFile "${nixos}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixos-${nixosVersion}";
        shared = import "${pythoneda-shared-pythonlang-banner}/nix/shared.nix";
        acmsl-licdata-artifact-application-for = { acmsl-licdata-artifact-domain, acmsl-licdata-artifact-events, acmsl-licdata-artifact-infrastructure, python
          , pythoneda-shared-pythonlang-banner
          , pythoneda-shared-pythonlang-domain
          , pythoneda-shared-pythonlang-application
          , pythoneda-shared-pythonlang-artf-application}:
          let
            pnameWithUnderscores =
              builtins.replaceStrings [ "-" ] [ "_" ] pname;
            pythonVersionParts = builtins.splitVersion python.version;
            pythonMajorVersion = builtins.head pythonVersionParts;
            pythonMajorMinorVersion =
              "${pythonMajorVersion}.${builtins.elemAt pythonVersionParts 1}";
            wheelName =
              "${pnameWithUnderscores}-${version}-py${pythonMajorVersion}-none-any.whl";
            banner_file = "${package}/licdata_artifact_banner.py";
            banner_class = "LicdataArtifactBanner";
          in python.pkgs.buildPythonPackage rec {
            inherit pname version;
            projectDir = ./.;
            pyprojectTomlTemplate = ./templates/pyproject.toml.template;
            pyprojectToml = pkgs.substituteAll {
              authors = builtins.concatStringsSep ","
                (map (item: ''"${item}"'') maintainers);
              desc = description;
              inherit homepage pname pythonMajorMinorVersion pythonpackage
                version;
              acmslLicdataArtifactDomain = acmsl-licdata-artifact-domain.version;
              acmslLicdataArtifactEvents = acmsl-licdata-artifact-events.version;
              acmslLicdataArtifactInfrastructure = acmsl-licdata-artifact-infrastructure.version;
              package = builtins.replaceStrings [ "." ] [ "/" ] pythonpackage;
              pythonedaSharedPythonlangBanner =
                pythoneda-shared-pythonlang-banner.version;
              pythonedaSharedPythonlangDomain =
                pythoneda-shared-pythonlang-domain.version;
              pythonedaSharedPythonlangApplication =
                pythoneda-shared-pythonlang-application.version;
              pythonedaSharedPythonlangArtfApplication =
                pythoneda-shared-pythonlang-artf-application.version;
              src = pyprojectTomlTemplate;
            };
            bannerTemplateFile = ./templates/banner.py.template;
            bannerTemplate = pkgs.substituteAll {
              project_name = pname;
              file_path = banner_file;
              inherit banner_class org repo;
              tag = version;
              pescio_space = space;
              arch_role = archRole;
              hexagonal_layer = layer;
              python_version = pythonMajorMinorVersion;
              nixpkgs_release = nixpkgsRelease;
              src = bannerTemplateFile;
            };

            entrypointTemplateFile =
              "${pythoneda-shared-pythonlang-banner}/templates/entrypoint.sh.template";
            entrypointTemplate = pkgs.substituteAll {
              arch_role = archRole;
              hexagonal_layer = layer;
              nixpkgs_release = nixpkgsRelease;
              inherit homepage maintainers org python repo version;
              pescio_space = space;
              python_version = pythonMajorMinorVersion;
              pythoneda_shared_pythoneda_banner =
                pythoneda-shared-pythonlang-banner;
              pythoneda_shared_pythoneda_domain =
                pythoneda-shared-pythonlang-domain;
              src = entrypointTemplateFile;
            };
            src = pkgs.fetchFromGitHub {
              owner = org;
              rev = version;
              inherit repo sha256;
            };

            format = "pyproject";

            nativeBuildInputs = with python.pkgs; [ pip poetry-core ];
            propagatedBuildInputs = with python.pkgs; [
              acmsl-licdata-artifact-domain
              acmsl-licdata-artifact-events
              acmsl-licdata-artifact-infrastructure
              pythoneda-shared-pythonlang-banner
              pythoneda-shared-pythonlang-domain
              pythoneda-shared-pythonlang-application
              pythoneda-shared-pythonlang-artf-application
            ];

            # pythonImportsCheck = [ pythonpackage ];

            unpackPhase = ''
              command cp -r ${src} .
              sourceRoot=$(ls | grep -v env-vars)
              command chmod -R +w $sourceRoot
              command cp ${pyprojectToml} $sourceRoot/pyproject.toml
              command cp ${bannerTemplate} $sourceRoot/${banner_file}
              command cp ${entrypointTemplate} $sourceRoot/entrypoint.sh
            '';

            postPatch = ''
              substituteInPlace /build/$sourceRoot/entrypoint.sh \
                --replace "@SOURCE@" "$out/bin/${entrypoint}.sh" \
                --replace "@PYTHONEDA_EXTRA_NAMESPACES@" "org" \
                --replace "@PYTHONPATH@" "$PYTHONPATH" \
                --replace "@CUSTOM_CONTENT@" "" \
                --replace "@PYTHONEDA_SHARED_PYTHONLANG_DOMAIN@" "${pythoneda-shared-pythonlang-domain}" \
                --replace "@PACKAGE@" "$out/lib/python${pythonMajorMinorVersion}/site-packages" \
                --replace "@ENTRYPOINT@" "$out/lib/python${pythonMajorMinorVersion}/site-packages/${package}/${entrypoint}.py" \
                --replace "@PYTHON_ARGS@" "" \
                --replace "@BANNER@" "$out/bin/banner.sh"
            '';

            postInstall = ''
              command pushd /build/$sourceRoot
              for f in $(command find . -name '__init__.py' | sed 's ^\./  g'); do
                if [[ ! -e $out/lib/python${pythonMajorMinorVersion}/site-packages/$f ]]; then
                  command mkdir -p $out/lib/python${pythonMajorMinorVersion}/site-packages/"$(command dirname $f)";
                  command cp -r "$(command dirname $f)"/* $out/lib/python${pythonMajorMinorVersion}/site-packages/"$(command dirname $f)";
                fi
              done
              command popd
              command mkdir $out/dist $out/bin
              command cp dist/${wheelName} $out/dist
              command cp /build/$sourceRoot/entrypoint.sh $out/bin/${entrypoint}.sh
              command chmod +x $out/bin/${entrypoint}.sh
              command echo '#!/usr/bin/env sh' > $out/bin/banner.sh
              command echo "export PYTHONPATH=$PYTHONPATH" >> $out/bin/banner.sh
              command echo "command echo 'Running $out/bin/banner'" >> $out/bin/banner.sh
              command echo "${python}/bin/python $out/lib/python${pythonMajorMinorVersion}/site-packages/${banner_file} \$@" >> $out/bin/banner.sh
              command chmod +x $out/bin/banner.sh
            '';

            meta = with pkgs.lib; {
              inherit description homepage license maintainers;
            };
          };
      in rec {
        apps = rec {
          default = acmsl-licdata-artifact-application-python311;
          acmsl-licdata-artifact-application-python39 = shared.app-for {
            package =
              self.packages.${system}.acmsl-licdata-artifact-application-python39;
            inherit entrypoint;
          };
          acmsl-licdata-artifact-application-python310 = shared.app-for {
            package =
              self.packages.${system}.acmsl-licdata-artifact-application-python310;
            inherit entrypoint;
          };
          acmsl-licdata-artifact-application-python311 = shared.app-for {
            package =
              self.packages.${system}.acmsl-licdata-artifact-application-python311;
            inherit entrypoint;
          };
          acmsl-licdata-artifact-application-python312 = shared.app-for {
            package =
              self.packages.${system}.acmsl-licdata-artifact-application-python312;
            inherit entrypoint;
          };
          acmsl-licdata-artifact-application-python313 = shared.app-for {
            package =
              self.packages.${system}.acmsl-licdata-artifact-application-python313;
            inherit entrypoint;
          };
        };
        defaultApp = apps.default;
        defaultPackage = packages.default;
        devShells = rec {
          default = acmsl-licdata-artifact-application-python311;
          acmsl-licdata-artifact-application-python39 =
            shared.devShell-for {
              banner = "${packages.acmsl-licdata-artifact-application-python39}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package =
                packages.acmsl-licdata-artifact-application-python39;
              python = pkgs.python39;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python39;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python39;
              inherit archRole layer org pkgs repo space;
            };
          acmsl-licdata-artifact-application-python310 =
            shared.devShell-for {
              banner = "${packages.acmsl-licdata-artifact-application-python310}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package =
                packages.acmsl-licdata-artifact-application-python310;
              python = pkgs.python310;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python310;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python310;
              inherit archRole layer org pkgs repo space;
            };
          acmsl-licdata-artifact-application-python311 =
            shared.devShell-for {
              banner = "${packages.acmsl-licdata-artifact-application-python311}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package =
                packages.acmsl-licdata-artifact-application-python311;
              python = pkgs.python311;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python311;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python311;
              inherit archRole layer org pkgs repo space;
            };
          acmsl-licdata-artifact-application-python312 =
            shared.devShell-for {
              banner = "${packages.acmsl-licdata-artifact-application-python312}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package =
                packages.acmsl-licdata-artifact-application-python312;
              python = pkgs.python312;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python312;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python312;
              inherit archRole layer org pkgs repo space;
            };
          acmsl-licdata-artifact-application-python313 =
            shared.devShell-for {
              banner = "${packages.acmsl-licdata-artifact-application-python313}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.acmsl-licdata-artifact-application-python313;
              python = pkgs.python313;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python313;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python313;
              inherit archRole layer org pkgs repo space;
            };
        };
        packages = rec {
          default = acmsl-licdata-artifact-application-python311;
          acmsl-licdata-artifact-application-python39 =
            acmsl-licdata-artifact-application-for {
              acmsl-licdata-artifact-domain =
                acmsl-licdata-artifact-domain.packages.${system}.acmsl-licdata-artifact-domain-python39;
              acmsl-licdata-artifact-events =
                acmsl-licdata-artifact-events.packages.${system}.acmsl-licdata-artifact-events-python39;
              acmsl-licdata-artifact-infrastructure =
                acmsl-licdata-artifact-infrastructure.packages.${system}.acmsl-licdata-artifact-infrastructure-python39;
              python = pkgs.python39;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python39;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python39;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python39;
              pythoneda-shared-pythonlang-artf-application =
                pythoneda-shared-pythonlang-artf-application.packages.${system}.pythoneda-shared-pythonlang-artf-application-python39;
            };
          acmsl-licdata-artifact-application-python310 =
            acmsl-licdata-artifact-application-for {
              acmsl-licdata-artifact-domain =
                acmsl-licdata-artifact-domain.packages.${system}.acmsl-licdata-artifact-domain-python310;
              acmsl-licdata-artifact-events =
                acmsl-licdata-artifact-events.packages.${system}.acmsl-licdata-artifact-events-python310;
              acmsl-licdata-artifact-infrastructure =
                acmsl-licdata-artifact-infrastructure.packages.${system}.acmsl-licdata-artifact-infrastructure-python310;
              python = pkgs.python310;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python310;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python310;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python310;
              pythoneda-shared-pythonlang-artf-application =
                pythoneda-shared-pythonlang-artf-application.packages.${system}.pythoneda-shared-pythonlang-artf-application-python310;
            };
          acmsl-licdata-artifact-application-python311 =
            acmsl-licdata-artifact-application-for {
              acmsl-licdata-artifact-domain =
                acmsl-licdata-artifact-domain.packages.${system}.acmsl-licdata-artifact-domain-python311;
              acmsl-licdata-artifact-events =
                acmsl-licdata-artifact-events.packages.${system}.acmsl-licdata-artifact-events-python311;
              acmsl-licdata-artifact-infrastructure =
                acmsl-licdata-artifact-infrastructure.packages.${system}.acmsl-licdata-artifact-infrastructure-python311;
              python = pkgs.python311;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python311;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python311;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python311;
              pythoneda-shared-pythonlang-artf-application =
                pythoneda-shared-pythonlang-artf-application.packages.${system}.pythoneda-shared-pythonlang-artf-application-python311;
            };
          acmsl-licdata-artifact-application-python312 =
            acmsl-licdata-artifact-application-for {
              acmsl-licdata-artifact-domain =
                acmsl-licdata-artifact-domain.packages.${system}.acmsl-licdata-artifact-domain-python312;
              acmsl-licdata-artifact-events =
                acmsl-licdata-artifact-events.packages.${system}.acmsl-licdata-artifact-events-python312;
              acmsl-licdata-artifact-infrastructure =
                acmsl-licdata-artifact-infrastructure.packages.${system}.acmsl-licdata-artifact-infrastructure-python313;
              python = pkgs.python312;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python312;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python312;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python312;
              pythoneda-shared-pythonlang-artf-application =
                pythoneda-shared-pythonlang-artf-application.packages.${system}.pythoneda-shared-pythonlang-artf-application-python312;
            };
          acmsl-licdata-artifact-application-python313 =
            pythoneda-acmsl-licdata-artifact-application-for {
              acmsl-licdata-artifact-domain =
                acmsl-licdata-artifact-domain.packages.${system}.acmsl-licdata-artifact-domain-python313;
              acmsl-licdata-artifact-events =
                acmsl-licdata-artifact-events.packages.${system}.acmsl-licdata-artifact-events-python313;
              acmsl-licdata-artifact-infrastructure =
                acmsl-licdata-artifact-infrastructure.packages.${system}.acmsl-licdata-artifact-infrastructure-python313;
              python = pkgs.python313;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python313;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python313;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python313;
              pythoneda-shared-pythonlang-artf-application =
                pythoneda-shared-pythonlang-artf-application.packages.${system}.pythoneda-shared-pythonlang-artf-application-python313;
            };
        };
      });
}
