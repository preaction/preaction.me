---
title: Retro Gaming with Raspberry Pi
layout: reveal.html
data:
    topic_url: preaction.me/rpi
    theme: black
---

<style>
.reveal img {
    max-height: 70vh;
}
.flexed {
    display: flex;
    height: 70vh;
    flex-flow: row wrap;
    justify-content: space-around;
}
.flexed img {
    flex: 0 1 auto;
}
.flexed.systems img {
    height: 30vh;
}
.flexed.games img {
    flex: 0 1 24%;
    height: 45vh;
    margin: 2px;
}
.img-and-list {
    display: flex;
    align-items: center;
    justify-content: center;
}
.img-and-list img {
    width: 40vw;
}
</style>

<div class="slides">
%= include 'deck/title.html.ep', title => $self->title
<section>
<section>
<h1>The Video Game Crash</h1>
<h2>1983</h2>
<aside class="notes">I was born during the video game crash of
1983. The video game industry wouldn't recover until 1987, with the
rising popularity of the Nintendo Entertainment System (NES).</aside>
</section>
<section data-background-color="white">
<div class="flexed systems">
<img src="nes.jpg">
<img src="gameboy.jpg">
<img src="snes.jpg">
<img src="genesis.jpg">
<img src="psx.jpg">
</div>
<aside class="notes">The next decade would see the most famous video
game consoles released.</aside>
</section>
<section>
<div class="flexed games">
<img src="mario.jpg">
<img src="sonic.jpg">
<img src="metroid.jpg">
<img src="zelda.jpg">
<img src="castlevania.jpg">
<img src="megaman.jpg">
<img style="width: 24%" src="final-fantasy.jpg">
<img src="metalgear.jpg">
</div>
<aside class="notes">... and many of the most famous video game
franchises would get their starts.</aside>
</section>
<section>
<h1>Nostalgia</h1>
<aside class="notes">But if you're in the mood to play some of these
games, you may be hard-pressed to find them.</aside>
</section>

<section>
<h1>Old Hardware</h1>
<img src="old-snes.jpg">
<aside class="notes">While I may still have a few working consoles and
some working games, I suspect not everyone is so lucky.</aside>
</section>

<section>
<h1>Re-releases</h1>
<img src="namco-museum.jpg">
<aside class="notes">Some companies have started to capitalize on
nostalgia through ports of old games for new consoles, like the Namco
Museum series.</aside>
</section>

<section>
<h1>New Old Hardware</h1>
<img src="nes-classic.jpg">
<aside class="notes">And some companies are releasing retro consoles
like Nintendo's NES Classic</aside>
</section>

<section>
<h1>Pre-loaded Games</h1>
<img src="nes-classic-menu.jpg">
<aside class="notes">The NES classic comes with 30 games preloaded, some
real gems, but might not have that one obscure game you fell in love
with.</aside>
</section>

<section>
<h1>Expensive</h1>
<aside class="notes">Maintaining the hardware to keep your nostalgia
demons at bay can get expensive, but there's another way that people
have been keeping this old hardware alive.</aside>
</section>

</section>

<!-- what is emulation -->

<section>

<section>
<h1>Software Simulation</h1>
<aside class="notes">Software simulation is using software to simulate
hardware.</aside>
</section>

<section>
<h1>Emulator</h1>
<aside class="notes">Software designed to fully simulate an entire
hardware system is generally called an "emulator".</aside>
</section>

<section data-background-color="black"
data-background-size="contain" data-background-image="xterm.png"
>
<h1>Terminal Emulator</h1>
<aside class="notes">Anyone who has used a "terminal" application on
a modern OS has used a "terminal emulator": The software emulates some
kind of terminal hardware.</aside>
</section>

<section data-background-color="black"
data-background-size="contain" data-background-image="nesticle.jpg"
>
<h1>Video Game</h1>
<h1>Console Emulator</h1>
<aside class="notes">Emulators for old video game systems have been
available since the first NES emulator was released in 1992 running on
a modest Intel 486/DX2.</aside>
</section>

<section>
<h1>Nintendo Virtual Console</h1>
<aside class="notes">The Nintendo Virtual Console, available since the
Nintendo Wii, uses emulation to play NES, Super NES, Game Boy and other
Nintendo games you can buy for a few dollars.</aside>
</section>

<section>
<h1>XBox 360</h1>
<h2>Backwards Compatibility</h2>
<aside class="notes">The XBox 360 used emulation to get some limited
support for the original XBox games.</aside>
</section>

<section>
<h1>PlayStation Store</h1>
<aside class="notes">Even the PlayStation Store sells emulated
games.</aside>
</section>

<section>
<h1>Consoles on Computers</h1>
<aside class="notes">I've been using console emulators on my computers
since the late 1990's (playing ROMs on school computers), and they've grown by leaps and bounds since
then.</aside>
</section>

<section data-background-color="black"
data-background-size="contain" data-background-image="openemu.png"
>
<h1>Frontends</h1>
<aside class="notes">More recently, projects have started to bundle up
a bunch of emulators into a single front-end program: You run one
application which lists all the consoles and games you have, making it
a lot easier to get playing.</aside>
</section>

<section>
<h1>Emulator Annoyances</h1>
<aside class="notes">There are some annoyances with using
a general-purpose computer as a video game console emulator.</aside>
</section>

<section>
<h1>Controllers</h1>
<aside class="notes">A lot of them are around controllers:
Plugging/unplugging USB controllers, connecting/disconnecting Bluetooth
controllers (Bluetooth remains the worst thing ever). Using a keyboard
is often difficult for games that weren't designed for keyboards:
Controllers have buttons wrapping around for different fingers to press.
A keyboard is a different control scheme for different game
experiences.</aside>
</section>

<section>
<h1>For Computer Experts</h1>
<aside class="notes">So, to me, emulation on my computer was mostly
a personal thing. I can deal with the problems as they come up: It's
less work than maintaining a Linux desktop. But that keeps this kind of
nostalgia away from casual computer users.</aside>
</section>

<section>
<h1>Nostalgia Availability</h1>
<aside class="notes">I know lots of people who would love to play the
games from their childhood and would have no clue how to debug the
problems of emulation on a desktop.  I also know so many people who were
kept out of video games as children, unable to play some of the games
that sparked my interest in technology, and even literally shaped my
personality growing up.</aside>
</section>

<section>
<h1>Raspberry Pi</h1>
<aside class="notes">So when I started hearing about the Raspberry Pi,
I wondered if some of these problems could be fixed. A small, cheap
computer system purpose-built for playing video games would solve the
issues of managing controllers, and the system could allow navigating
lists of games via the same controllers.</aside>
</section>

<section>
<h1>A Gift</h1>
<h2 class="fragment">Beyond my Expectations</h2>
<aside class="notes">So I started this project to give my girlfriend the
Super NES from her childhood. But as I've been working on it for the
last few months, I found it could do a lot more.</aside>
</section>

<section>
<h1>5th-generation</h1>
<aside class="notes">I thought this would only be good for emulating
a Super NES (basically a 6502 processor at 3.5 MHz, with an audio
co-processor and some other chips), but I've played some N64 and
PlayStation 1 games on this thing with only a few issues.</aside>
</section>

</section>

<!-- legal question -->

<section>

<section>
<h1>Legality</h1>
<aside class="notes">Before we start talking about how to build this
system, we should talk about copyright law.</aside>
</section>

<section>
<h1>I Am Not A Lawyer</h1>
<aside class="notes">I am not a lawyer</aside>
</section>

<section>
<h1>This is Not Legal Advice</h1>
<aside class="notes">I am not trained or licensed to give legal advice.</aside>
</section>

<section>
<h1>Emulators are Legal</h1>
<h3>(In the U.S.)</h3>
<aside class="notes">According to current legal precedent, emulator software is
legal to develop and possess.</aside>
</section>

<section>
<h1>Reverse Engineering</h1>
<h1>is Legal</h1>
<h4>Sega v. Accolade (1992)</h4>
<aside class="notes">Sega v. Accolade established that reverse
engineering the Sega Genesis software is protected under the fair use
doctrine (and trademark law can't be used to make reverse engineering
illegal).</aside>
</section>

<section>
<h1>Copying Firmware</h1>
<h1>is Legal</h1>
<h4>Sony Computer Entertainment, Inc. v. Connectix Corporation (2000)</h4>
<aside class="notes">Years later, the PlayStation was released, and
almost immediately people started trying to emulate it. Connectix let
you play PlayStation games on MacOS (the original). Sony sued them
because they had to copy the PS1's BIOS firmware to do it. Connectix
eventually prevailed.</aside>
</section>

<section>
<h1>Emulators</h1>
<h1>are Legal</h1>
<h4>Sony Computer Entertainment America v. Bleem (2000)</h4>
<aside class="notes">Which led to Bleem!, a PlayStation emulator that
allowed playing PlayStation game disks on PCs and Sega Dreamcast. Bleem!
ultimately won in court, but court costs forced them out of
business.</aside>
</section>

<section>
<h1>Games are Copyrighted</h1>
<aside class="notes">Game cartridges contain software which is protected
by copyright law.</aside>
</section>

<section>
<h1>Downloading ROMs is Illegal</h1>
<aside class="notes">There is no legal precedent that would presently
allow for you to download ROM dumps of games, even ones you physically own.</aside>
</section>

<section>
<h1>Archival Copying May Be Legal</h1>
<aside class="notes">There is legal precedent that fair use allows for
backup/archival copies of certain kinds of media, but there has been no
specific case about ROMs inside video game cartridges. The hardware to
do this is highly specialized, and from what I've read, difficult to use
at best.</aside>
</section>

<section>
<h1>Clear about Legality?</h1>
<aside class="notes">Everyone clear about the legality of this?</aside>
</section>

<section>
<h1>Let's move on...</h1>
<aside class="notes">Let's move on...</aside>
</section>

</section>

<!-- What is Raspberry Pi -->
<section>

<section>
<h1>Raspberry Pi</h1>
<img src="raspberry-pi-logo.png">
<aside class="notes">A Raspberry Pi is an inexpensive, single-board ARM
computer developed to help teach basic computer science in schools and
developing countries. Like other projects of this nature, it also became
popular outside its target market.</aside>
</section>

<section>
<h1>Model 1 A</h1>
<div class="img-and-list">
<img src="raspberry-pi-model-a.jpg">
<ul>
    <li class="fragment">MicroUSB power
    <li class="fragment">HDMI video/audio
    <li class="fragment">3.5mm audio output
    <li class="fragment">MicroSD card
    <li class="fragment">USB-A ports
    <li class="fragment">GPIO Pins
</ul>
</div>
<aside class="notes">Here's one of the first models. All Pis rely on
Broadcom System-on-a-Chip (SoC) processors, and as many peripheral ports
as they can pack on to the form factor. All RaspberryPis have MicroUSB
for power, HDMI for video/audio output, 3.5mm audio output, a MicroSD
card for internal storage, USB-A ports for keyboard/mouse/etc..., and
general-purpose I/O pins of varying number and usage.</aside>
</section>

<section>
<h1>Model 3 B+</h1>
<div class="img-and-list">
<img src="raspberry-pi-model-3b-plus.jpg">
<ul>
    <li class="fragment">4-core 1.4 GHz ARM
    <li class="fragment">1GB SDRAM
    <li class="fragment">Bluetooth
    <li class="fragment">802.11ac WiFi
    <li class="fragment">GigE Ethernet
</ul>
</div>
<aside class="notes">The most powerful Raspberry Pi model, and the one
I picked for this project, comes with a 4-core 1.4 GHz ARM Cortex-A53
processor with 1GB SDRAM, Bluetooth, 802.11ac dual-band wireless, and
Gigabit Ethernet.</aside>
</section>

<section>
<h1>Model Zero</h1>
<img src="raspberry-pi-zero.jpg">
<aside class="notes">There's even a Raspberry Pi Zero with only
a mini-HDMI port and a micro-USB port that costs $5 (or $10 for the
version with wireless networking).</aside>
</section>

</section>

<!-- buying the system -->
<section>

<section>
<h1>Building A Pi</h1>
<aside class="notes">Building a Raspberry Pi system is similar to
building your own computer from scratch</aside>
</section>

<section>
<h1>You Will Need</h1>
<aside class="notes">To build my system, I bought</aside>
</section>

<section>
<h3>Raspberry Pi</h3>
<img style="height: 50vh" src="raspberry-pi-model-3b-plus.jpg">
<h1>Model 3B+</h1>
<aside class="notes">The Raspberry Pi Model 3B+. Available for $35
online or at MicroCenter on Elston.</aside>
</section>

<section>
<h3>Power Supply</h3>
<img style="height: 50vh" src="microusb-power.jpg">
<h2>5.1V, 3A MicroUSB</h2>
<aside class="notes">A 5.1-volt, 3-amp power adapter with a MicroUSB
connector. Microcenter had one for $11.</aside>
</section>

<section>
<h1>MicroSD card</h1>
<img style="height: 40vh" src="microsd.jpg">
<h2>16-64 GB</h2>
<aside class="notes">A MicroSD card. These are so inexpensive now
I splurged and spent a whole $20 on a 64-GB one. I originally bought
a 16-GB one for $10. For playing older games, 16-GB is well more than
enough: The OS takes 3-4GB, leaving 12 for games. The largest SNES games
are 48 megabit (6 megabytes uncompressed, 3.5 compressed). I filled this
thing with every NES, SNES, Genesis, Game Boy, Game Boy Color, Game Boy
Advance game that has ever held my attention for 5 minutes and still
have 11 GB left. However, if you're going to emulate the N64, the
cartridges are much larger, up to 70MB. And the PS1 used CD-ROMs which
could store up to 660MB. These will require more storage, so buy the
card you'll need.</aside>
</section>

<section>
<h1>HDMI Cable (6ft)</h1>
<img style="height: 60vh" src="hdmi.jpg">
<aside class="notes">To connect to the display, you'll need an HDMI
cable. Microcenter had a 6-ft one for $15.</aside>
</section>

<section>
<h1>Raspberry Pi Case</h1>
<img src="official-case.jpg">
<aside class="notes">And you'll need a case. The official case is good
for getting started and is only $9. Later, I'll talk about custom cases
with extra features (that cost more).</aside>
</section>

<section>
<h1>You Will Also Need</h1>
<div class="img-and-list">
<img src="cardreader.jpg">
<ul>
    <li class="fragment">An HDMI display (TV)
    <li class="fragment">MicroSD reader ($15)
    <li class="fragment">USB keyboard ($8)
</ul>
</div>
<aside class="notes">I did not buy a new TV for this, any TV will do. To
create the bootable MicroSD card, I needed a card reader which can be
used for any SD card reading needs. Parts of the initial setup require
a USB keyboard, but I had a few laying around. You can buy one if you
need for less than $10.</aside>
</section>

<section>
<h1>Controllers</h1>
<aside class="notes">Since this is a video game console, I also bought
some controllers.</aside>
</section>

<section>
<h1>iNNext Super NES</h1>
<img style="height: 60vh" src="innext-snes-controllers.jpg">
<aside class="notes">My goal was mainly to emulate 3rd- and 4th-gen
consoles, so Super NES controllers are perfect. Lots of companies
produce retro controllers with USB connectors, and I found these for $13
for the pair on Amazon. They said they came with 6ft cords, but one was
a foot short. For $6.50 each, I'm not complaining. Besides, my living
room is larger than 6ft either way, so I bought some 10ft USB-2
extension cords for $10 each.</aside>
</section>

<section>
<h1>DualShock 4</h1>
<img style="height: 60vh" src="ps4-controller.jpg">
<aside class="notes">If you want to play PS1 games or N64 games, you're
going to need a more expensive controller. I've found the PS4 controller
to be the most useful for general gaming: It's laid out like a Super NES
controller, works perfect for PS1 games, and can be made to work for N64
games (with the wierd pitchfork design), though the C-buttons on the N64
are emulated using the right analog stick. This controller is, however,
$50, which inflates the prices of this system dramatically.</aside>
</section>

<section>
<h1>Nintendo<br/>Pro Controller</h1>
<img style="height: 60vh" src="wii-u-pro-controller.jpg">
<aside class="notes">For a similar experience more modestly proced, the
Wii-U or Switch Pro Controller is good as well.</aside>
</section>

<section>
<h1>XBox Controllers</h1>
<h2>Not All Bluetooth</h2>
<aside class="notes">Not all modern XBox controllers support real
Bluetooth, but some do. I prefer the PS4 controller though...</aside>
</section>

<section>
<h1>Total Price</h1>
<div style="display: flex">
<ul style="list-style: none">
<li class="fragment" data-fragment-index="1">Raspberry Pi Model 3B+
<li class="fragment" data-fragment-index="2">5.1V, 3A MicroUSB power adapter
<li class="fragment" data-fragment-index="3">64GB MicroSD card
<li class="fragment" data-fragment-index="4">HDMI cable (6ft)
<li class="fragment" data-fragment-index="5">Official RPi case
<li class="fragment" data-fragment-index="6">iNNext Super NES Controllers
<li class="fragment" style="border-top: 1px solid white" data-fragment-index="7">Total
</ul>
<ul style="list-style: none">
<li class="fragment" data-fragment-index="1">$35
<li class="fragment" data-fragment-index="2">$11
<li class="fragment" data-fragment-index="3">$20
<li class="fragment" data-fragment-index="4">$15
<li class="fragment" data-fragment-index="5">$9
<li class="fragment" data-fragment-index="6">$13
<li class="fragment" style="border-top: 1px solid white" data-fragment-index="7">$103
</ul>
</section>

<section>
<h1>Assembling</h1>
<aside class="notes">Now that we have our Pi, we need to assemble it</aside>
</section>

<section>
<h1>Official Case</h1>
<img src="official-case-apart.jpg">
<aside class="notes">The official case comes in 5 parts</aside>
</section>

<section>
<img src="assemble-1.jpg">
<aside class="notes">The Raspberry Pi sits in the bottom, held by pins</aside>
</section>

<section>
<img src="assemble-4.jpg">
<aside class="notes">Then snap closed the top and sides and the Pi is
ready.</aside>
</section>

</section>

<!-- installing an os -->
<section>

<section>
<h1>Software</h1>
<ul>
<li class="fragment">Operating System
<li class="fragment">Emulators
<li class="fragment">Front-end
</ul>
<aside class="notes">With our hardware ready, next we need to get some software</aside>
</section>

<section>
<img src="retropie-logo.png">
<aside class="notes">We can get all of these through the RetroPie
project. RetroPie is a project for retro gaming on Raspberry Pi.</aside>
</section>

<section>
<h1>Disk Image</h1>
<ul>
<li class="fragment">Raspbian
<li class="fragment">Emulators (libretro)
<li class="fragment">EmulationStation
</ul>
<aside class="notes">The project releases disk images with all the
software you need to set up a retro gaming machine. The image contains
a Debian-based OS called Raspbian, a set of emulators using libretro for
a unified experience, and an emulator front-end called EmulationStation.</aside>
</section>

<section>
<img src="download-retropie.png">
<a href="http://retropie.co.uk">http://retropie.co.uk</a>
<aside class="notes">Download the Raspberry Pi disk image from
RetroPie's website. Be sure to download the correct one for your
Raspberry Pi model. It should come as a ".img" file.</aside>
</section>

<section>
<h1>Writing Images</h1>
<aside class="notes">In order to boot our system, we need to write our
image to our SD card. There are lots of ways to do this, your OS
probably has a disk utility or there's the <code>dd</code>
command.</aside>
</section>

<section>
<h1>Etcher</h1>
<img src="etcher-site.png">
<aside class="notes">The Raspberry Pi project recommends Etcher, so I'll
show that. It's certainly the simplest, friendliest way to do it.
Download and install Etcher from their website.</aside>
</section>

<section>
<h1>Choose an Image</h1>
<img src="etcher-step-1.png">
<aside class="notes">Once it's running, select an image (the RetroPie
image)</aside>
</section>

<section>
<h1>Select a Disk</h1>
<img src="etcher-step-5.png">
<aside class="notes">Make sure to plug in your SD card and your SD card
reader, then select the disk.</aside>
</section>

<section>
<h1>Flash and Wait</h1>
<img src="etcher-step-7.png">
<aside class="notes">Then click the Flash button. Once it's started, it
may ask for administrator permissions to write to the raw disk,
obliterating anything on the SD card.</aside>
</section>

<section>
<h1>Wait More</h1>
<img src="etcher-step-10.png">
<aside class="notes">Once the image is written, Etcher will verify the
data to try to detect any write errors.</aside>
</section>

<section>
<h1>Done!</h1>
<img src="etcher-step-11.png">
<aside class="notes">And then it's done! Your SD card is ready to boot.
Plug it in to the bottom of the Raspberry Pi.</aside>
</section>

</section>

<!-- first boot -->
<section>

<section>
<h1>First Boot</h1>
<aside class="notes">To boot the Pi</aside>
</section>

<section>
<h1>Plug in</h1>
<h3 class="fragment">Keyboard</h3>
<h3 class="fragment">Controller</h3>
<h3 class="fragment">HDMI</h3>
<h3 class="fragment">Power</h3>
<aside class="notes">Plug in the keyboard, wired controllers, HDMI, and power supply.</aside>
</section>

<section>
<h1>Boot Screen</h1>
<aside class="notes">The next thing you'll see on your TV is a small
Raspberry Pi logo followed by the noisy Linux boot before it's
interrupted by a RetroPie splash screen.</aside>
</section>

<section>
<h1>Expand Filesystem</h1>
<aside class="notes">The first boot will take a little longer as it
expands the root filesystem, a consequence of using a pre-built
filesystem on a disk images instead of building a filesystem on a target
disk and copying the OS on to that.</aside>
</section>

<section data-background-image="emulation-station-load.png">
<aside class="notes">The next thing you'll see is the EmulationStation
loading picture. Once this is loaded...</aside>
</section>

<section data-background-image="controller-setup-1.png">
<aside class="notes">It will ask you to configure a controller. The
controller will be used by EmulationStation to move through the menus
and launch games.</aside>
</section>

<section data-background-image="controller-setup-2.png">
<aside class="notes">Holding down a button will select a controller, and
EmulationStation will ask you to hit certain buttons to map buttons to
values. You'll see things like "Button 9" or "Axis 1+" show
up. These are the internal IDs of the buttons and analog sticks of the
controller.</aside>
</section>

<section data-background-image="controller-setup-4.png">
<aside class="notes">Because I'm using a Super NES controller, some of
the buttons EmulationStation asks for I don't have. SNES has left/right
shoulder buttons, but not left/right trigger buttons or left/right thumb
buttons. Holding any button down for a few seconds will skip it.
EmulationStation supports all the buttons that have become standard for
PS4/XBox/Pro controllers.</aside>
</section>

<section data-background-image="controller-setup-5.png">
<aside class="notes">And one additional button: The hotkey. This key is
a modifier key like the Shift/Ctrl/Alt key. Pressing it and another
button will control the emulator. More on that later. The hotkey can be
the same as another button, so for my Super NES, I use the Select
button. For controllers with a "Home" or "System" button, I recommend
using that.</aside>
</section>

<section data-background-image="emulation-station-menu.png">
<aside class="notes">Now we can see the EmulationStation menu. We only
have one option right now: RetroPie. This option contains configuration
and settings for our machine. Later, after we've added some games,
additional options will show up.</aside>
</section>

</section>

<!-- configuring network -->
<section>

<section>
<h1>Adding Games</h1>
<aside class="notes">There are two ways to add games. The easiest way is
to use the Samba network file share to copy games over the network. To
do that, we either have to plug in an Ethernet cable, or configure the
wireless.</aside>
</section>

<section>
<h1>Configure Wireless</h1>
<aside class="notes">Wireless is more portable, so let's walk through
setting that up.</aside>
</section>

<section>
<h1>Configure Country</h1>
<aside class="notes">First thing we need to do is configure which
country we're in. Different countries use different radio frequencies
for Wifi, and we definitely do not want to break FCC regulation and run
some kind of pirate wifi radio station (or be unable to find our
networks, whichever).</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="es-retropie-menu.png">
<aside class="notes">To configure our country, we go into the RetroPie
menu, and choose the <code>raspi-config</code> option.</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="raspi-config-menu.png">
<aside class="notes">Oh. This looks different. Anyone who's worked with
Debian a lot might recognize this as very similar to debconf, which it
is. With the keyboard I can move down to Localization Settings and hit
Enter. I can do it with the controller too, but keyboard is a lot
easier.</aside>
</section>

<section>
<h1>Localization Settings</h1>
<img src="localization-menu.png">
<aside class="notes">From this menu, we select Change Wi-Fi Country.</aside>
</section>

<section>
<h1>Wi-Fi Country</h1>
<img src="country-menu.png">
<aside class="notes">Using a keyboard helps on this menu, because
a keyboard has a page-down key and there are a lot of countries. Once we
found ours, we can hit Enter to select it.</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="es-retropie-menu.png">
<aside class="notes">With our country configured, we can set up our Wifi
networking. Go down to Wifi in the RetroPie menu.</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="wifi-menu.png">
<aside class="notes">On this menu we choose "Connect to a Wifi network"
to select from a list of networks.</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="wifi-network-list.png">
<aside class="notes">We find the network we want.</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="wifi-password.png">
<aside class="notes">Type in our password</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="wifi-connect.png">
<aside class="notes">Wait for it to connect</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="wifi-connected.png">
<aside class="notes">And we're done. Hit the right-arrow to select
"Exit" and hit Enter to leave.</aside>
</section>

</section>

<!-- transferring games -->
<section>

<!-- samba -->
<section>
<h1>Transfer Games</h1>
<aside class="notes">With our network configured, we can now copy some
games with Samba.</aside>
</section>

<section>
<h1>Samba</h1>
<aside class="notes">Samba is a Windows file-sharing protocol that's
been adapted to other OSes and is now widely available.</aside>
</section>

<section>
<h1>Connect to Server</h1>
<img src="samba-connect.png">
<aside class="notes">How to connect
to a Samba share depends on your OS, but for OS X, use the Finder, click
"Go > Connect to Server" and type in <kbd>smb://retropie</kbd>. The
RetroPie uses mDNS (Bonjour) for internal DNSing (fully-qualified it
would be "retropie.local").</aside>
</section>

<section>
<h1>Credentials</h1>
<img src="samba-auth.png">
<aside class="notes">You'll be prompted for credentials, and you can
just log on as "Guest".</aside>
</section>

<section>
<h1>Shares</h1>
<img src="samba-shares.png">
<aside class="notes">There are multiple shares here: BIOS is for
emulators that require BIOS images, like the PlayStation. Configs is all
the configuration files if we want to edit them. ROMs is where we'll
copy our games. Splashscreens are images to use when booting the
RetroPie.</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="samba-roms.png">
<aside class="notes">If we connect to the ROMs folder, we see a whole
bunch of directories. Each directory corresponds to an emulated system.
Some systems have multiple names (Genesis and Mega Drive are the same
machine)</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="samba-roms-snes-game.png">
<aside class="notes">Since I have an SNES game, I put it in the SNES
folder. A lot of emulators support zipped ROMs to save space.</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="restart_1.png">
<aside class="notes">Once we've transferred our ROM, we need to restart
EmulationStation to reload the list of games. Press Start to enter the
menu. Go down to the bottom, "Quit" and press A</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="restart_2.png">
<aside class="notes">And choose Restart EmulationStation and press A</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="restart_3.png">
<aside class="notes">Yes really...</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="restart_4.png">
<aside class="notes">Now we can see our new system</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="restart_5.png">
<aside class="notes">And if we press A to enter the system, we see our game</aside>
</section>

<!-- USB -->

<section data-background-color="black"
data-background-size="contain"
data-background-image="usb-empty.png">
<h1>USB</h1>
<aside class="notes">If you're having trouble with Samba, or don't want
to configure networking, you can transfer files using a USB stick. Make
sure it's formatted FAT32 (for Windows).</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="usb-retropie.png">
<aside class="notes">Create a "retropie" directory on the USB stick and
then plug it in to the RaspberryPi and wait a few minutes.</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="usb-retropie-filled.png">
<aside class="notes">RetroPie will create a directory structure in that
"retropie" folder.</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="usb-retropie-roms.png">
<aside class="notes">Just like the Samba share, there's a ROMs folder
here with all the systems inside</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="usb-retropie-snes.png">
<aside class="notes">Which we can add a game to</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="usb-roms-copied.png">
<aside class="notes">And then plug the USB stick into the Pi. RetroPie
will copy the game onto our SD card (it does not play the game off the
stick).</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="restart_3.png">
<aside class="notes">We can then restart EmulationStation</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="usb-game-list.png">
<aside class="notes">And our new game appears in our menu</aside>
</section>

<!-- scraping metadata -->

<section>
<h1>Metadata</h1>
<aside class="notes">These lists look plain, though. If I hadn't played
these games enough to remember everything about them, I wouldn't know
what game I was looking for. It'd be nice to see a cover image and
a description of the game.</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="scraper-1.png">
<img src="scraper-1.png">
<aside class="notes">Fortunately, EmulationStation comes with a way to
download metadata for games called "Scraper" in the main menu.</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="scraper-3.png">
<aside class="notes">From the scraper menu, we can set up the source of
The Games DB and go down to Scrape Now.</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="scraper-4.png">
<aside class="notes">Then we set up what we want to scrape. Usually
these defaults are good enough: If we just added a game, it will be
missing an image.</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="scraper-5.png">
<aside class="notes">The next screen that appears will have the name of
the our file and a list of search results from The Games DB. We have to
pick which result is correct for our file. This will take a few minutes,
especially if you have a lot of games.</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="scraper-7.png">
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="scraper-8.png">
<aside class="notes">But when you're done you'll have a much nicer view
of your games with box art and publisher and other useful details!</aside>
</section>


</section>

<!-- playing games -->
<section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="play-1.png">
<aside class="notes">Now we can play a game!</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="play-1.png">
<h1>Hotkeys</h1>
<aside class="notes">While we're inside our game, we can use the Hotkey
to do some useful things</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="play-1.png">
<h1>Quit<br/>Hotkey + Start</h1>
<aside class="notes">Hotkey + Start will quit the emulator. Super
important for those of us who still need to sleep.</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="play-1.png">
<h1>Restart<br/>Hotkey + B</h1>
<aside class="notes">Hotkey + B will restart the system</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="play-1.png">
<h1>Save state<br/>Hotkey + R</h1>
<aside class="notes">Hotkey + R will save the current memory state</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="play-1.png">
<h1>Load state<br/>Hotkey + L</h1>
<aside class="notes">Hotkey + L will load it. Emulators are great in
that you can save/load your game at any time, even games that don't have
a built-in save function!</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="play-2.png">
<h1>Menu<br/>Hotkey + X</h1>
<aside class="notes">And Hotkey + X will show the emulator menu. There's
a lot of stuff in here, including the hotkeys I already mentioned, and
configuration per-system and per-game.</aside>
</section>

</section>

<!-- customize -->
<section>

<section>
<h1>Customizing</h1>
<aside class="notes">That's all there is to getting started, but there's
a lot more that this little machine can do.</aside>
</section>

<section>
<h1>Themes</h1>
<aside class="notes">The default RetroPie EmulationStation theme is kind
of boring to me, so I tried a few out.</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="theme-set-1.png">
<aside class="notes"></aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="theme-set-2.png">
<aside class="notes"></aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="theme-set-3.png">
<aside class="notes"></aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="theme-set-4.png">
<aside class="notes"></aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="theme-set-5.png">
<aside class="notes"></aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="theme-set-6.png">
<aside class="notes"></aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="themes-1.png">
<aside class="notes"></aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="themes-2.png">
<aside class="notes"></aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="themes-3.png">
<aside class="notes"></aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="themes-4.png">
<aside class="notes"></aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="themes-5.png">
<aside class="notes"></aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="themes-6.png">
<aside class="notes"></aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="themes-7.png">
<aside class="notes"></aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="themes-8.png">
<aside class="notes"></aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="themes-9.png">
<aside class="notes"></aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="themes-10.png">
<aside class="notes"></aside>
</section>

<section>
<h1>Custom Cases</h1>
<aside class="notes">You can customize the case for your machine. The
default case is okay, but one thing it lacks is a power switch.</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="kintaro-snes-front.jpg">
<h1>SNES Case</h1>
<aside class="notes">Here's the Super-NES-alike case I bought for $35.
It includes a soft power switch that sends the right signal to the OS to
shutdown gracefully instead of just cutting the power (no IPMI here, so
it uses the GPIO pins).</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="kintaro-snes-rear.jpg">
</section>

</section>

<section>
<section>
<h1>Pitfalls</h1>
<aside class="notes">One last thing before I go</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="overscan-1.png">
<h1>Overscan</h1>
<aside class="notes">If your TV has these black bars all around the
edge, you can fix it by disabling overscan.</aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="overscan-2.png">
<aside class="notes">Go into the Advanced Settings menu and there's an
"Overscan" item.</aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="overscan-3.png">
<aside class="notes">It'll ask if you want to enable overscan, and you
have to choose "No" to disable it. I got confused a few times by this
dialog...</aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="overscan-4.png">
<aside class="notes">Hooray</aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="overscan-5.png">
<aside class="notes">Except, no, the machine is lying to me. When I go
to Finish...</aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="overscan-6.png">
<aside class="notes">I'm prompted to reboot</aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="overscan-after-1.png">
<aside class="notes">And now the black bars are gone</aside>
</section>

<section data-background-color="black"
data-background-size="contain"
data-background-image="bluetooth-1.png">
<h1>Bluetooth</h1>
<aside class="notes">Every once in a while I'll need to connect
a keyboard to fix the bluetooth. Bluetooth controllers are best paired
and left alone. Don't try to use them with multiple things or you'll
have to go through the tedious menus again...</aside>
</section>
<section data-background-color="black"
data-background-size="contain"
data-background-image="bluetooth-2.png">
<h1>Bluetooth</h1>
<aside class="notes">Because like all the other menus, these are not
exactly controller-friendly (though controllers do work here, if you
only have bluetooth controllers, you'll need something else to connect
your first one)</aside>
</section>

</section>

<!-- Wrap-up -->
<section>

<section>
<h1>Questions?</h1>
<ul>
<li>Full slides: <a href="http://preaction.me/rpi">http://preaction.me/rpi</a></li>
</ul>
<div style="text-align: center">
    <a href="http://preaction.me">
        <img src="http://preaction.me/images/avatar-small.jpg" style="display: inline-block; max-width: 100%"/>
    </a>
</div>
</section>

<section>
<h1>Live Demo?</h1>
</section>

<section>
<h1>Thank you!</h1>
</section>

</section>

</div>
