# Creative Commons BY-SA :  Regis d'Aubarede <regis.aubarede@gmail.com>

class Fire < Tank
  COLORS=%w{994400 AA4400 BB4400 CC4400 DD4400 EE4400 FF4400 FFAA00 FFBB88 FFCCAA}
  def initialize(x,y) 
    super(x,y,"#00AA00") ; 
    @r=10
    @r0=0
    @i=0
  end
  def draw(w,cr)
    COLORS.size.downto(@r) { |r|
      w.draw_circle(@x-2+rand(4),@y-2+rand(4),r+3,"#"+COLORS[r],"#"+COLORS[r]) rescue nil
    }
  end
  def anim    
    @r=[@r0+rand(3),COLORS.size].min
    @r0+=1
    $app.dead(self) if @r0>=COLORS.size
    @i+=1
  end
end