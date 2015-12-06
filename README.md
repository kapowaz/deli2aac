deli2aac
========

A small Ruby script for converting Amiga game music files into AAC using uade and afconvert.

Requirements
------------

You must install the [Unix Amiga Delitracker Emulator](http://zakalwe.fi/uade/) (e.g. `brew install uade`) as well as the Mac OS X Developer Tools (either the command line tools or Xcode).

Usage
-----

`$ deli2aac somegame.mod`

…will generate a 256 kbps AAC audio file called somegame.mod.m4a in the same directory. If the MOD file contains multiple subsongs it will split these out (e.g. `somegame.mod_01.m4a`). You can also supply a path to a directory containing several files and it'll try and convert all of the files in that directory by the same mechanism. Oh yeah, you'll need to be on a Mac, too, and it requires the [colored gem](http://rubygems.org/gems/colored).

TODO
----

Probably needs some tidying up, as this was just something rudimentary to get it working. Probably doesn't handle errors very well. Something to handle alternative platforms (LAME for MP3?) and check for required gems would be nice too.