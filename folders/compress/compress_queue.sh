tsp bash -c 'd="$(realpath "$1")"; p="$(dirname "$d")"; b="$(basename "$d")"; (cd "$p" && zip -r "$b.zip" "$b") && rm -rf -- "$d"' _ "path/to/folder"
