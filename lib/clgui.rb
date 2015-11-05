##
# Class for drawing pixels on Unicode VT100 terminals.
class CLGUI
  ##
  # Configures terminal for drawing.
  def initialize
    @stty_state=`stty -g`
    @h,@w=`stty size`.split.map{|x|x.to_i}
    `stty raw -echo -icanon isig`
    print 27.chr+"[?25l"
    print 27.chr+"[2J"
    @display=Array.new(h){Array.new(w,0)}
    @@POS=[[0,3],[1,4],[2,5],[6,7]]
  end
  ##
  # Cleans up before exiting.
  def close
    `stty #{@stty_state}`
    print 27.chr+"[?25h"
    print 27.chr+"[2J"
  end
  def chr_on(x,y,bit)
    bit=bit%8
    @display[y][x]=@display[y][x]|(1<<bit)
  end
  def chr_change(x,y,bit)
    bit=bit%8
    @display[y][x]=@display[y][x]^(1<<bit)
  end
  def chr_off(x,y,bit)
    bit=bit%8
    @display[y][x]=@display[y][x]&~(1<<bit)
  end
  def chr_test(x,y,bit)
    @display[y][x]&(1<<bit)!=0
  end
  def pxl_on(x,y)
    self.chr_on((x/2).floor,(y/4).floor,@@POS[y%4][x%2])
  end
  def pxl_off(x,y)
    self.chr_off((x/2).floor,(y/4).floor,@@POS[y%4][x%2])
  end
  def pxl_change(x,y)
    self.chr_change((x/2).floor,(y/4).floor,@@POS[y%4][x%2])
  end
  def pxl_test(x,y)
    self.chr_test((x/2).floor,(y/4).floor,@@POS[y%4][x%2])
  end
  def line(x1,y1,x2,y2)
    s=(y2-y1).abs>(x2-x1).abs
    if s
      x1,y1=y1,x1
      x2,y2=y2,x2
    end
    if x1>x2
      x1,x2=x2,x1
      y1,y2=y2,y1
    end
    dx=x2-x1
    dy=(y2-y1).abs
    e=dx/2
    ys=y1<y2 ? 1 : -1
    y=y1
    x1.upto(x2){|x|
      if s
        self.pxl_on(y,x)
        yield y,x
      else
        self.pxl_on(x,y)
        yield x,y
      end
      e-=dy
      if e<0
        y+=ys
        e+=dx
      end
    }
  end
  def draw_chr(x,y)
    print 27.chr+"["+(y+1).to_s+";"+(x+1).to_s+"H"
    print [@display[y][x]+10240].pack("U")
    print 27.chr+"[1;1H"
  end
  def draw_pxl(x,y)
    self.draw_chr((x/2).floor,(y/4).floor)
  end
  def draw_screen
    print 27.chr+"[2J"
    @display.each_index{|n|
      print 27.chr+"["+(n+1).to_s+";1H"
      print @display[n].map{|x|x+10240}.pack("U*")
    }
    print 27.chr+"[1;1H"
  end
  def w
    @w*2
  end
  def h
    @h*4
  end
end
