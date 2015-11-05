# clgui
This library lets you draw pixels on the terminal using the Unicode 
Braille characters. There's 2x4 "pixels" in every character, so a 80x24 
terminal gives you a drawable 160x96 "screen". Pretty useful for remote 
connections! Of course, your terminal should emulate a standard VT100.

This library includes functions to draw in your terminal (loosely 
inspired by the TI-83+ line of graphic calculators) along with a few 
examples. Of course, don't expect every pixels being lined up perfectly, 
it depends of your font. Which should support the Braille characters.
