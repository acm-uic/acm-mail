{pkgs ? import <nixpkgs>{ }, ...}:

let domain = "acm.cs.uic.edu";
    certPath = "/etc/cert.pub";
    certKey = "/etc/cert.key";
in
pkgs.dockerTools.buildImage {
  name = "acm-opensmtpd";
  tag = "latest";

  contents = [pkgs.opensmtpd pkgs.opensmtpd-filter-rspamd pkgs.bash pkgs.coreutils];

  runAsRoot = ''
            #!${pkgs.runtimeShell}
            mkdir -p /mail/
            cat << EOF > /mail/smtpd.conf
            pki ${domain} cert ${certPath}
            pki ${domain} key ${certKey}

            filter check_dyndns phase connect match rdns regex { '.*\.dyn\..*', '.*\.dsl\..*' }
                disconnect "550 no residential connections"

            filter check_rdns phase connect match !rdns
                disconnect "550 no rDNS is so 80s"

            filter check_fcrdns phase connect match !fcrdns
                disconnect "550 no FCrDNS is so 80s"

            filter rspamd proc-exec "filter-rspamd -url http://rspamd:11333"

            table aliases file:/mail/aliases

            # listen on all tls pki 
            #    filter { check_dyndns, check_rdns, check_fcrdns, rspamd }
            # I think listening on port 25 is pretty useless. Use smtps/starttls

            listen on all port submission tls-require pki acm.cs.uic.edu auth filter { check_dyndns, check_rdns, check_fcrdns, rspamd}
            listen on all port smtps tls-require pki ${domain} auth filter { check_dyndns, check_rdns, check_fcrdns, rspamd }

            action "local_mail" maildir junk
            action "outbound" relay helo ${domain}

            match from any for domain ${domain} action "local_mail"
             match for local action "local_mail"

            match from any auth for any action "outbound"
            match for any action "outbound"
  '';

  config = {
    Cmd = ["${pkgs.opensmtpd}/bin/smtpd" "-d" "-f" "/mail/smtpd.conf"];
    ExposedPorts = {
      "587" = {};
      "465" = {};
    };
    Volumes = {
      "/etc" = {};
      "/home" = {};
    };
  };
}
