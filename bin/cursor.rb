#!/usr/bin/ruby
# Cursor demo, arrows to move, ^C to quit

require "clgui"

def read_char
  input = STDIN.getc.chr
  if input == "\e" then
    input << STDIN.read_nonblock(3) rescue nil
    input << STDIN.read_nonblock(2) rescue nil
  end
  return input
end

d=CLGUI.new
d.draw_screen
trap "SIGINT" do
  d.close
  exit 0
end
x=d.w/2
y=d.h/2
d.pxl_on(x,y)
d.draw_pxl(x,y)
d.line(40,0,0,20){|a,b|d.draw_pxl(a,b)}
while 1 do
  c = read_char
  case c
    when "\e[A" # up
      d.pxl_change(x,y)
      d.draw_pxl(x,y)
      y=y-1 if y>0
      d.pxl_change(x,y)
      d.draw_pxl(x,y)
    when "\e[B" # down
      d.pxl_change(x,y)
      d.draw_pxl(x,y)
      y=y+1 if y<d.h-1
      d.pxl_change(x,y)
      d.draw_pxl(x,y)
    when "\e[C" # right
      d.pxl_change(x,y)
      d.draw_pxl(x,y)
      x=x+1 if x<d.w-1
      d.pxl_change(x,y)
      d.draw_pxl(x,y)
    when "\e[D" # left
      d.pxl_change(x,y)
      d.draw_pxl(x,y)
      x=x-1 if x>0
      d.pxl_change(x,y)
      d.draw_pxl(x,y)
  end
end
