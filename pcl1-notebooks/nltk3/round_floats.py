#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# simon.clematide@uzh.ch
# PCL I
#
# Möglichst fehlerfreies Runden ist ein schwieriges Thema:
# http://en.wikipedia.org/wiki/Rounding#Round_half_away_from_zero

print("Zahlen runden")

print("round(0.05,1) ==>", round(0.05,1))
print("round(0.15,1) ==>", round(0.15,1))
print("round(0.25,1) ==>", round(0.25,1))
print("round(0.35,1) ==>", round(0.35,1))
print("round(0.45,1) ==>", round(0.45,1))
print("round(0.55,1) ==>", round(0.55,1))
print("round(0.65,1) ==>", round(0.65,1))
print("round(0.75,1) ==>", round(0.75,1))
print("round(0.85,1) ==>", round(0.85,1))
print("round(0.95,1) ==>", round(0.95,1))

print()
print("'Runden' durch die Formatierung")

print("{:.1f}.format(0.05) ==>",'{:.1f}'.format(0.05))
print("{:.1f}.format(0.15) ==>",'{:.1f}'.format(0.15))
print("{:.1f}.format(0.25) ==>",'{:.1f}'.format(0.25))
print("{:.1f}.format(0.35) ==>",'{:.1f}'.format(0.35))
print("{:.1f}.format(0.45) ==>",'{:.1f}'.format(0.45))
print("{:.1f}.format(0.55) ==>",'{:.1f}'.format(0.55))
print("{:.1f}.format(0.65) ==>",'{:.1f}'.format(0.65))
print("{:.1f}.format(0.75) ==>",'{:.1f}'.format(0.75))
print("{:.1f}.format(0.85) ==>",'{:.1f}'.format(0.85))
print("{:.1f}.format(0.95) ==>",'{:.1f}'.format(0.95))
