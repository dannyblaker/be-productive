# Be Productive

Welcome to "Be Productive", a collection of useful scripts and commands I use on a daily basis as a professional software developer.

## Example:

Here's one of my favourites... a one-liner that recursively deletes all empty folders, starting from the current directory:

```sh
while true; do output=$(sudo find . -type d -empty -exec rmdir {} \; 2>&1); echo "$output"; if [ -z "$output" ]; then echo "Output is empty."; break; fi done
```

**You are most welcome to use this code in your commercial projects, all that I ask in return is that you credit my work by providing a link back to this repository. Thank you & Enjoy!**

**System**: Ubuntu 24.04.X LTS

# Setup

1. Install dependancies

```sh
bash install_deps.sh
```

2. Create all `.env` files

```sh
bash create_env_files.sh
```


# Run

## Script Type 1

Scripts that have the following at the beginning...
```sh
#!/bin/bash

set -a
source .env
set +a
```
... read inputs via a `.env` located in the same directory as the script. 

Therefore:

Step 1: modify the `.env` as needed
Step 2: navigate to the directory containing the script and run using `bash`

## Script Type 2

Scripts that have do **not** have `#!/bin/bash...` at the beginning contain commands that can be copied and pasted directly into the terminal. Make any modifications as needed.

# Tools
The following are additional tools I use to increase productivity:

## Ubuntu App Center

[Inkscape](https://inkscape.org/)

## Snap store

[Draw.io](https://snapcraft.io/install/drawio/ubuntu#install)

## Other

Tool    Website Installation Docs
n8n https://n8n.io/ https://docs.n8n.io/hosting/installation/npm/
node-red  https://nodered.org/    https://nodered.org/docs/getting-started/local

| Tool     | Website                  | Installation Docs                                             |
|----------|--------------------------|---------------------------------------------------------------|
| VS code | [code.visualstudio.com](https://code.visualstudio.com/) | [Docs](https://code.visualstudio.com/download) |
| chrome | [chrome](https://www.google.com/intl/en_au/chrome/dr/download/) | [Docs](https://www.google.com/intl/en_au/chrome/dr/download/) |
| nvm      | [nvm](https://github.com/nvm-sh/nvm) | [Docs](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating)         |
| n8n      | [n8n.io](https://n8n.io/) | [Docs](https://docs.n8n.io/hosting/installation/npm/)         |
| node-red | [nodered.org](https://nodered.org/) | [Docs](https://nodered.org/docs/getting-started/local) |