# Creative Commons BY-SA :  Regis d'Aubarede <regis.aubarede@gmail.com>

class Bullet < Tank
  def initialize(origine,x0,y0,dir) 
    super(x0,y0,"#BB2222") 
    @parent,@a,@v=origine,dir,40
  end
  def draw(w,cr) w.draw_circle(@x,@y,3,@coul,@coul)  end
  def dead()     @parent.dead_bullet end
  def anim(c)
    move()
    if x<=0 || y<=0 ||x>=$W || y>=$H
      $app.dead(self)
      return
    end
    $app.test_collision(self,@parent)
  end
end