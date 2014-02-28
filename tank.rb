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
    @state=""
    @count_bullet=0
  end
  # draw radar, body+wheels, cannon
  def draw(w,cr)
    #p [self.class,@coul]
    w.draw_line([@x,@y,@x+300*cos(@cradar),@y+300*sin(@cradar)],"#00A000") if @cradar!=0
    w.rotation(@x,@y,deg2rd(@a)) { 
      w.draw_rectangle(-5,-5,10,10,0,@coul,@coul) 
      w.draw_line([-7,-5,+7,-5],"#000000",2) 
      w.draw_line([-7,+5,+7,+5],"#000000",2) 
    }
    w.draw_line([@x,@y,@x+10*cos(@cdir),@y+10*sin(@cdir)],"#000000")
  end
  def turn_cannon(dr) @cdir=alimit(@cdir+dr)       end
  def turn_radar(dr)  @cradar=alimit(@cradar+dr)   end
  def dead_bullet()   @count_bullet-=1  ; p "deadb"           end
  def count_bullet()  @count_bullet                end
  def fire()          (@count_bullet+=1 ; $app.creatBullet(self,@x,@y,@cdir)) if @count_bullet<6 end
  def fire_good?
    $app.each_tank(self).select { |t| inline?(t,10) }.size>0
  end
  def tir(condition,option,&blk)
     if condition  
        puts "tir to #{option[:state]}..."
        to_state(option[:state])
        blk.call if blk
     end
  end
end
