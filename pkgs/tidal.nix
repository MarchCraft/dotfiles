{
  lib,
  stdenv,
  makeWrapper,
}:
stdenv.mkDerivation {
  pname = "tidal";
  version = "1.0";

  src = ../scripts; # Path to your script, adjust as needed

  nativeBuildInputs = [makeWrapper];

  meta = with lib; {
    description = "A script that launches chromium with tidal";
    license = licenses.mit;
    platforms = platforms.all;
  };

  buildPhase = ''
    # Install the bash script
    mkdir -p $out/bin
    cp $src/tidal.sh $out/bin/tidal.sh
    chmod +x $out/bin/tidal.sh

    # Create the .desktop file
    mkdir -p $out/share/applications
    cat <<EOF > $out/share/applications/tidal.desktop
    [Desktop Entry]
    Version=1.0
    Name=Tidal
    Comment=Launch Tidal on Chromium
    Exec=bash $out/bin/tidal.sh
    Icon=utilities-terminal
    Terminal=true
    Type=Application
    Categories=Utility;
    EOF

    chmod +x $out/share/applications/tidal.desktop
  '';

  installPhase = ''
    # Install the .desktop file to the appropriate location
    mkdir -p $out/share/applications

    # Optionally install the script in the user's environment
    mkdir -p $out
    cp -r $src/* $out/
  '';
}
