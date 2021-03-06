#!/bin/zsh

############################################################################
#			checkvers
#
#	Automatically check for newer version of programs
############################################################################

# Global variables
cr="\033[1;31m"
cg="\033[1;32m"
ce="\033[0m"
cpt=0
[[ $1 == "-q" ]] && quiet=1

cd `dirname $0`/..

# Script output: start
[[ ! $quiet ]] && printf "%36s %8s   %8s\n" "Package" "PkgVer" "PrgVer"

showver() {
	curver=$(grep "pkgver=" --color=never $1/PKGBUILD | cut -d "=" -f2)
	col=$cr
	[[ $curver == $2 ]] && col=$cg || cpt=$[ cpt + 1 ]
	[[ ! $quiet ]] && printf "%35s: $col%8s$ce | $cg%8s$ce\n" $1 $curver $2
}


# Check versions

# CPU-X
newver=$(elinks -dump -no-references "https://github.com/X0rg/CPU-X/tags" | grep "]v" --color=never \
	| awk '{ print $1 }' | cut -d "v" -f2 | head -n1)
showver cpu-x $newver

# DMG2DIR
newver=$(elinks -dump -no-references "https://github.com/X0rg/dmg2dir/tags" | grep "]v" --color=never \
	| awk '{ print $1 }' | cut -d "v" -f2 | head -n1)
showver dmg2dir $newver

# DMG2IMG
newver=$(elinks -dump -no-references "http://vu1tur.eu.org/tools/" | grep "dmg2img" --color=never \
	| grep "-" --color=never | awk '{ print $1 }' | cut -d "-" -f2 | cut -d ":" -f1 | head -n1)
showver dmg2img $newver

# Exaile
www=$(elinks -dump -no-references "https://github.com/exaile/exaile/releases" | grep "exaile" --color=never \
        | grep ".tar.gz" --color=never | cut -d "-" -f2 | head -n1)
newver=${www%%".tar.gz"*}
showver exaile $newver

# FrozenWay
newver=$(elinks -dump -no-references "http://www.frozendo.com/frozenway/download" \
	| grep "Version" --color=never | awk '{ print $2 }' | tail -n1)
showver frozenway $newver

# LibAOSD
newver=$(elinks -dump -no-references "https://github.com/atheme/libaosd/releases" | grep "…" --color=never \
        | cut -d "]" -f2 | cut -d " " -f1 | head -n1)
showver libaosd $newver

# MemTest86
newver=$(elinks -dump -no-references "http://www.memtest86.com/download.htm" | grep "MemTest86 V" --color=never |
	grep "Free Edition" --color=never | awk '{ print $2 }' | cut -d "V" -f2)
showver memtest86-efi $newver

# Python2-MMKeys
www=$(elinks -dump -no-references "http://sourceforge.net/projects/sonata.berlios/files/" \
	| grep "sonata" --color=never | awk '{ print $1 }' | cut -d "]" -f2 | cut -d "-" -f2 | grep ".tar.gz" --color=never | head -n1)
newver=${www%%".tar.gz"}
showver python2-mmkeys $newver

# RadeonTop
newver=$(elinks -dump -no-references "https://github.com/clbr/radeontop/releases" | grep "]v" --color=never \
	| awk '{ print $1 }' | cut -d "v" -f2 | head -n1)
showver radeontop $newver

# Psensor
www=$(elinks -dump -no-references "http://wpitchoune.net/psensor/files/")
www=$(echo $www | awk '{ print $2 }' | grep "psensor-" --color=never | cut -c14- | tail -n1)
newver=${www%%".tar.gz.asc"*}
showver psensor $newver

# Rhythmbox lLyrics
newver=$(elinks -dump -no-references "https://github.com/dmo60/lLyrics/tags" | grep "]v" --color=never \
	| awk '{ print $1 }' | cut -d "v" -f2 | head -n1)
showver rhythmbox-llyrics $newver


# Script output: end
if [[ $quiet ]]; then
	echo -e "$cpt"
else
	[[ $cpt == 0 ]] && col=$cg || col=$cr
	echo -e "\nOut-of-date packages : $col$cpt$ce"
fi
