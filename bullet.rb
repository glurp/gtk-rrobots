
class Bullet < Tank
  def initialize(origine,x0,y0,dir) 
    super(x0,y0,"#992222") 
    @parent,@a,@v=origine,dir,30
  end
  def draw(w,cr)
    w.draw_circle(@x,@y,3,@coul,@coul) 
  end
  def anim()
    move()
    if x==0 || y==0 ||x==200 || y==200
      $app.dead(self)
      return
    end
    $app.test_collision(self,x,y)
  end
end