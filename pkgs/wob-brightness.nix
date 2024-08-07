{
  writeShellApplication,
  acpilight,
}:
writeShellApplication {
  name = "wob-brightness";

  runtimeInputs = [
    acpilight
  ];

  text = ''
    if (( $# < 1 )); then
        cat << END
    usage: brightness <value>

    <value> is passed as-is to xbacklight
    END
        exit
    fi

    xbacklight "$@"

    if [ -z "$WOBSOCK" ]; then
        exit
    fi

    LEVEL=$(xbacklight -getf | sed 's/[^0-9]0//g')
    echo "$LEVEL brightness" > "$WOBSOCK"
  '';
}
