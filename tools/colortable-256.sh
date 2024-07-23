#!/bin/bash


cols=$(tput cols)

# How many cols has grid layout?
for g_cols in 6 3 2 1; do
	if (( g_cols*32 < cols )); then
		break
	fi
done
echo

# 16 colors
for row in 0 1; do
	for col in {0..7}; do
		color=$(( row*8 + col ))
		printf "\033[48;5;${color}m  %-3d  \033[0m " $color # L=8
	done
	echo
done
echo

# 216 colors table: 6×6×6 cube: 16 + 36×r + 6×g + b
for (( g_row=0; g_row < 6/g_cols; g_row++ )); do
	for (( row=0; row < 6; row++ )); do
		for (( col=0; col < 6*g_cols; col++ )); do
			if (( col > 0 && col % 6 == 0 )); then
				echo -n "..." # pad between blocks
			fi

			color=$(( 16 + g_row*6*g_cols + row*36 + col ))
			printf "\033[48;5;%dm %3d \033[0m" $color $color # L=5
		done
		echo
	done
	echo
done

# Grayscale from black to white in 24 steps
for gray in {232..255}; do
	echo -ne "\033[48;5;${gray}m  $gray  \033[0m " # L=8
	if (( ++n/4 == g_cols )); then
		n=0; echo
	fi
done
echo
