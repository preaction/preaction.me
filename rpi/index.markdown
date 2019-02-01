---
title: Raspberry Pi - Tiny Computing Power
---

# Raspberry Pi

The [Raspberry Pi](https://raspberrypi.org) is a tiny, low-cost computer
designed for teaching computer science to students. It also has myriad
practical applications in the modern home.

## Talks

### Retro Gaming With RetroPie

* [Version 1 - Chicago.PM - 2018-09-27](talks/retropie-chicago-pm-2018)
* [Version 2 - Toronto.PM - 2019-01-31](talks/retropie-toronto-pm-2019)

This talk is about playing retro games with video game console emulators
on the Raspberry Pi. It explains what emulators are, how to buy
a Raspberry Pi, how to install [RetroPie](http://retropie.co.uk), and
how to configure and customize the system.

The RetroPie project comes with
[EmulationStation](http://emulationstation.org) and makes heavy use of
[libretro](https://libretro.com) to create a seamless experience
across multiple emulators.

If you want to build a retro gaming computer from scratch, this talk has
everything you need!

<!-- ## Articles -->
<!-- ## Related Topics -->

## Extra Resources

### [raspi2png](https://github.com/AndrewFromMelbourne/raspi2png)

This simple program reads the Raspberry Pi's graphics buffer to create
a screenshot. It does not require any desktop environment or GUI to be
present, and can take screenshots of anything.

I used this along with the below shell script to create all the
screenshots for my RetroPie talk. The shell script was an infinite loop
that took a screenshot every 3 seconds and then beeped, allowing me to
perform an action, wait for the beep, and perform another action. This
made it very easy to get all the screenshots I needed without having to
switch between game controller, keyboard, and laptop.

    #!/bin/bash
    # burst.sh - Take a burst of screenshots
    # Usage:
    #   burst.sh <delay> <basename> <count>
    delay=$1
    basename=$2
    count=$3
    for NUM in $(seq 1 $count); do
        sleep $delay
        name=${basename}_$NUM.png
        raspi2png -p $name
        echo -ne "\a"
    done
