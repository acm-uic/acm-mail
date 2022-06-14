{pkgs ? import <nixpkgs> {}, ...}:

pkgs.dockerTools.buildImage {
  name = "acm-rspamd";
  tag = "latest";

  contents = [pkgs.rspamd pkgs.coreutils pkgs.bash]; # remove coreutils and bash for prod

  runAsRoot = ''mkdir -p /var/log/rspamd'';
  config = {
    ExposedPorts = {
      "11332" = {};
      "11334" = {};
      "11335" = {};
    };
    Cmd = ["${pkgs.rspamd}/bin/rspamd" "-i" "-f"];
  };

}
