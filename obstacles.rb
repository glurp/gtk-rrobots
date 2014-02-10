# Creative Commons BY-SA :  Regis d'Aubarede <regis.aubarede@gmail.com>

class Obstacle < Tank
  def initialize(x,y,r) 
    super(x,y,"#FFAA00") ; 
    @r=r
  end
  def obstacle?() true end
  def intersect(other)
    ( (x-other.x)*(x-other.x)+ (y-other.y)*(y-other.y) ) < (@r+5)*(@r+5)
  end
  def draw(w,cr)
    w.draw_circle(@x,@y,@r,"#AAAAAA","#BBBBBB") 
  end
  def anim(c)
  end
end