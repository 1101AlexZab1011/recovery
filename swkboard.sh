#!/bin/bash

(setxkbmap -query | grep -q "layout:\s\+us") && setxkbmap ru || setxkbmap us