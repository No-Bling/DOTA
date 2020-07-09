#!/bin/sh
printf "\e[8;35;80t"; reset

# manually override required STEAMPATH variable here if needed
export STEAMPATH="$HOME/.local/share/Steam"

# check STEAMPATH and other Steam installation paths
export STEAMPATH1="$HOME/.local/share/Steam"
export STEAMPATH2="$HOME/.steam/steam"
export STEAMPATH3="$HOME/.var/app/com.valvesoftware.Steam/data/Steam"
export STEAMPATH4="$HOME/Library/Application Support/Steam"
for s in "$STEAMPATH" "$STEAMPATH1" "$STEAMPATH2" "$STEAMPATH3" "$STEAMPATH4"
do
  if test -f "$s/steamapps/libraryfolders.vdf"; then
    export STEAMPATH="$s"
    break  
  fi
done

if ! test -f "$STEAMPATH/steamapps/libraryfolders.vdf"; then
  printf "\e[1;7;91m"; read -s -n 1 -p "[ERROR] STEAMPATH not found! Set it manually in the script"; printf "\e[0m\n"; exit 1
fi

# add run helper and desktop shortcut
export EXEPATH=$(cd "$(dirname "$0")"; pwd -P)
cd "$EXEPATH"; pkill -f "mono vpkmod" >/dev/null; rm -f vpkmod >/dev/null
shortcut="$HOME/Desktop/No-Bling-DOTA.desktop"
printf "[Desktop Entry]\nName=No-Bling-DOTA\nType=Application\nTerminal=true\nExec=\"$EXEPATH/vpkmod.sh\"" > "$shortcut"
printf "#!/bin/sh\nprintf \"\\\\e[8;35;80t\"; reset\ncd \"$EXEPATH\"\nexport STEAMPATH=\"$STEAMPATH\"\n" > vpkmod.sh
printf "mono vpkmod -b -s \nsteam steam://rungameid/570" >> vpkmod.sh
chmod +x "$shortcut"; chmod +x vpkmod.sh 

# csc compile vpkmod tool via mono
if ! type mono > /dev/null 2>&1; then
  printf "\e[1;7;91m"; read -s -n 1 -p "[ERROR] You need to install mono"; printf "\e[0m\n"; exit 1  
fi
csc /out:vpkmod /target:exe /platform:anycpu /optimize /nologo vpkmod.cs
chmod +x vpkmod

# launch vpkmod with -b option for building No-Bling DOTA mod
mono vpkmod -b

read -s -n 1 -p "Press any key to start DOTA ";
steam steam://rungameid/570
