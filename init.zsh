#!/bin/zsh

# Check script options
if [[ "$#" -lt 1 ]]; then
    echo "Usage: ./init.zsh MyAddonName [folder]"
    exit 1
fi

if [[ $(echo "$1" | head -c 1) == "-" ]]; then
    echo "Usage: ./init.zsh MyAddonName [folder]"
    exit 1
fi

# Check script necessary tools : sed, perl, perl-rename
PERL=$(command -v perl)
if [[ ! -x "$PERL" ]] ; then
  echo "Install perl"
  exit 1
fi

RENAME=$(command -v perl-rename)
if [[ ! -x "$RENAME" ]] ; then
  RENAME=$(command -v rename)
fi

# Probe rather than read --help: Homebrew's rename takes the same perl
# expression as perl-rename but never prints PERLEXPR, so parsing the help text
# rejects a tool that would have worked. The darwin bypass this replaces meant a
# genuinely missing rename went unnoticed there instead.
RENAME_PROBE=$(mktemp -d)
: > "$RENAME_PROBE/probe_a"
( cd "$RENAME_PROBE" && "$RENAME" 's/probe_a/probe_b/' probe_a ) >/dev/null 2>&1
if [[ ! -e "$RENAME_PROBE/probe_b" ]]; then
  rm -rf "$RENAME_PROBE"
  echo "Install perl-rename (sometimes called just 'rename')"
  exit 1
fi
rm -rf "$RENAME_PROBE"

SED=/usr/bin/sed
if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! [[ -x "$(command -v gsed)" ]]; then
    echo "Install gnu-sed"
    exit 1
  fi
  SED=$(command -v gsed)
fi


ADDON="$1"
ADDON_LC=$(echo $ADDON | $PERL -ne 'print lc')
ADDON_LC_DASHES=$(echo $ADDON_LC | sed 's/_/-/g')

ADDON_DIR="$PWD"

if [[ "x$2" != "x" ]]; then
  TARGET_FOLDER="$2"
  mkdir -p "$TARGET_FOLDER"
  cp -rf * "$TARGET_FOLDER/"
  cd "$TARGET_FOLDER"
else
  TARGET_FOLDER="$PWD"
fi

mv "MyAvndEffect" "$ADDON"
$RENAME "s/my_avnd_effect/$ADDON_LC/" **/*.{hpp,cpp,txt}
$RENAME "s/MyAvndEffect/$ADDON/" **/*.{hpp,cpp,txt}
$SED -i "s/my_avnd_effect/$ADDON_LC/g" **/*.{hpp,cpp,txt,json}
$SED -i "s/MyAvndEffect/$ADDON/g" **/*.{hpp,cpp,txt,json} release.sh
$SED -i "s/my-avnd-effect/$ADDON_LC_DASHES/g" **/*.{hpp,cpp,txt,json} release.sh

echo -e "# $ADDON\nA new and wonderful [ossia score](https://ossia.io) add-on" > README.md


# One uuid for the whole add-on. score matches localaddon.json's "key" against
# the PLUGIN_UUID compiled into the plug-in, and rejects the add-on outright if
# they differ -- so every file has to carry the same one. Running uuidgen inside
# find -exec minted a fresh uuid per file instead.
# addon.json also carries the placeholder as a display name, which no
# rename above touches -- every add-on made from this template shipped as
# "My Avnd Effect" in the add-on manager.
$SED -i "s/My Avnd Effect/$ADDON/g;s/My Device/$ADDON/g;s/My Process/$ADDON/g" addon.json 2>/dev/null || true

ADDON_UUID=$(uuidgen)
find . \( -name '*.hpp' -o -name '*.cpp' -o -name '*.json' -o -name '*.txt' \) \
  -exec $PERL -pi -e "s|00000000-0000-0000-0000-000000000000|$ADDON_UUID|gi" {} \;

rm -rf .git
git init
rm init.sh init.zsh

