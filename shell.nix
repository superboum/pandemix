let pkgs = import <nixpkgs> {};
in (pkgs.buildFHSUserEnv {
   name = "FHS";
   targetPkgs = pkgs: [
     pkgs.chez
     pkgs.gtk3
     pkgs.gst_all_1.gstreamer
     pkgs.glib
   ]; #  Packages to be installed for the main host’s architecture (i.e. x86_64 on x86_64 installations). Along with libraries binaries are also installed.
   multiPkgs = pkgs: [ ]; # Packages to be installed for all architectures supported by a host (i.e. i686 and x86_64 on x86_64 installations). Only libraries are installed by default.
   runScript = "bash";
   profile = "";
}).env
