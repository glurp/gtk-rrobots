# Creative Commons BY-SA :  Regis d'Aubarede <regis.aubarede@gmail.com>

# a tank have
#   a move direction, a speed 
#   a connon with a direct
#   a radar with his direction
#   a move of the tank move cannon and radar
#   a turn of tank do same turn to cannonand radar
#
class Tank < Mobile 
  def initialize(x,y,coul="#AA0000")
    super
    @count_bullet=0
  end
  # draw radar, body+wheels, cannon
  def draw(w,cr)
    #p [self.class,@coul]
    w.draw_line([@x,@y,@x+300*Math.cos(@cradar),@y+300*Math.sin(@cradar)],"#00A000") if @cradar!=0
    w.rotation(@x,@y,@a) { 
      w.draw_rectangle(-5,-5,10,10,0,@coul,@coul) 
      w.draw_line([-7,-5,+7,-5],"#000000",2) 
      w.draw_line([-7,+5,+7,+5],"#000000",2) 
    }
    w.draw_line([@x,@y,@x+10*Math.cos(@cdir),@y+10*Math.sin(@cdir)],"#000000")
  end
  def turn_cannon(dr)
    @cdir=angle(@cdir+dr) 
  end
  def turn_radar(dr)  
      @cradar=angle(@cradar+dr) 
  end
  def fire
    @count_bullet+=1
    $app.creatBullet(self,@x,@y,@cdir)
  end
  def dead_bullet()  @count_bullet-=1 end
  def count_bullet() @count_bullet end
  def anim
    move
  end
  def fire_good?
    $app.each_tank(self).select { |t|
      dx,dy=t.x-x, t.y-y
      h=Math.sqrt(dx*dx+dy*dy)
      b=Math.atan2(dy,dx)
      aa=angle(b-@cradar)
      d= h*Math.sin(aa)
      d.abs<10
    }.size>0
  end
end
