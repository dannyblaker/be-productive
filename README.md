Welcome to "Be Productive", a collection of useful scripts and commands I use on a daily basis as a professional software developer.

**OS**: Ubuntu 24.04.X LTS

[![A Danny Blaker project badge](https://github.com/dannyblaker/dannyblaker.github.io/blob/main/danny_blaker_project_badge.svg)](https://github.com/dannyblaker/)

![be productive logo](be_productive_logo.png)

## Example:

Here's one of my favourites... a one-liner that recursively deletes all empty folders, starting from the current directory:

```sh
while true; do output=$(sudo find . -type d -empty -exec rmdir {} \; 2>&1); echo "$output"; if [ -z "$output" ]; then echo "Output is empty."; break; fi done
```

See [script here](./folders/delete/delete_empty_dirs_one_liner.sh)

Note: In some places I've included comments *below* a command as opposed to *above* in order to make copying and pasting faster.

# Setup

1. Install frameworks

- Docker Desktop
- VS code
- NVM (install https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating), then run `nvm install node` 

2. Install dependancies

```sh
bash install_deps.sh
```

3. Create all `.env` files

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

| Tool     | Website                  | Installation Docs                                             |
|----------|--------------------------|---------------------------------------------------------------|
| VS code | [code.visualstudio.com](https://code.visualstudio.com/) | [Docs](https://code.visualstudio.com/download) |
| chrome | [chrome](https://www.google.com/intl/en_au/chrome/dr/download/) | [Docs](https://www.google.com/intl/en_au/chrome/dr/download/) |
| nvm      | [nvm](https://github.com/nvm-sh/nvm) | [Docs](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating)         |
| n8n      | [n8n.io](https://n8n.io/) | [Docs](https://docs.n8n.io/hosting/installation/npm/)         |
| node-red | [nodered.org](https://nodered.org/) | [Docs](https://nodered.org/docs/getting-started/local) |