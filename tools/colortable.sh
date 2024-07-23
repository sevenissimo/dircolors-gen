#!/bin/bash


text="gYw"
cols=$(tput cols)

# Set margin and padding
# Default xs: p, m empty
[[ $cols -ge 50 ]] && p=" "	 # sm
[[ $cols -ge 60 ]] && m=" "  # md
[[ $cols -ge 78 ]] && p="  " # lg


# Table header
echo -ne "\n$m     $m$p   $p" # pad
for bg in {40..47}; do
	echo -n "$m$p${bg}m$p"
done
echo

# Table body
for fg in "" {30..37}; do
	for hi in "" "1;"; do
		# Row header
		printf "$m%5s" "${hi}${fg}m"

		# 1st cell w/o bg
		echo -ne "$m\033[${hi}${fg}m$p${text}$p\033[0m"

		# All other cells
		for bg in {40..47}; do
			echo -ne "$m\033[${hi}${fg}m\033[${bg}m$p${text}$p\033[0m"
		done
		echo
	done
done
echo
