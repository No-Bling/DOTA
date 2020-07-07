#!/bin/sh

# manually override required STEAMPATH variable here if needed
export STEAMPATH="$HOME/.local/share/Steam"

# check STEAMPATH
if ! test -f "$STEAMPATH/steamapps/libraryfolders.vdf"; then
    printf "\033[33m[ERROR] STEAMPATH not found! Set it manually in the script"
fi

# prepare
printf "\e[8;35;80t"; reset
export EXEPATH=$(cd "$(dirname "$0")"; pwd -P)
cd "$EXEPATH"; pkill -f "mono vpkmod" >/dev/null; rm -f vpkmod >/dev/null
shortcut="$HOME/Desktop/No-Bling-DOTA.desktop"
printf "[Desktop Entry]\nName=No-Bling-DOTA\nType=Application\nTerminal=true\nExec=\"$EXEPATH/vpkmod.sh\"" > "$shortcut"
printf "#!/bin/sh\nprintf \"\\\\e[8;35;80t\"; reset\n cd \"$EXEPATH\"\n STEAMPATH=\"$STEAMPATH\" mono vpkmod -b -s" > vpkmod.sh
chmod +x "$shortcut"; chmod +x vpkmod.sh 

# csc compile vpkmod tool via mono
if ! type mono > /dev/null 2>&1; then
    printf "\033[33m"; read -s -n 1 -p "[ERROR] You need to install mono "; exit 1
fi
csc /out:vpkmod /target:exe /platform:anycpu /optimize /nologo vpkmod.cs
chmod +x vpkmod

# launch vpkmod with -b option for building No-Bling DOTA mod
mono vpkmod -b
