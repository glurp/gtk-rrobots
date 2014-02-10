# Creative Commons BY-SA :  Regis d'Aubarede <regis.aubarede@gmail.com>

class Mobile
  attr_reader :x,:y,:cdir,:cradar
  def tank?() false end
  def obstacle?() false end  
  def initialize(x,y,coul="#AA0000")
    @x,@y,@coul=x,y,coul
    @count=0
    @v=0
    @a,@cdir,@cradar=0,0,0
    @parent
  end
  def draw(w,cr)
      w.draw_rectangle(x-5,y-5,10,10,0,@coul,@coul) 
  end
  def angle(a0)
      a=a0
      a -= 2.0*Math::PI while a > 2.0*Math::PI
      a += 2.0*Math::PI while a < 0
      a
  end
  
  def intersect(other)
    ( (x-other.x)*(x-other.x)+ (y-other.y)*(y-other.y) ) < 8*8
  end
  def accelerate(c) @v= @v.abs<1 ? 1 : @v*=c end
  def turn(c) 
     @a+=c
     @cdir+=c
     @cradar+=c
  end
  def move()
    nx= @x+@v*Math.cos(@a)/10
    ny=@y+@v*Math.sin(@a)/10
    @x=[0,nx,200].sort[1]
    @y=[0, ny,200].sort[1]
    if $app.obstacle?(self)
      @v=-@v
    end
    @v=0 if nx!=@x || ny!=@y
  end
  def childr?(t)      t==@parent end
  def turn_to(a)
     @cdir+= a-@a
     @cradar+= a-@a
     @a=a
  end
  def pxy() 
    puts " #{@coul}: @ %4f/%4f v=%4f}/%4f  dir=#{@a} canon=#{@cdir} radar=#{@cradar} #{self.class.to_s}" % [@x,@y,@dx,@dy]
  end
  def mindist?()
     x<5 || y<5 || x>195 || y>195
  end
  def _anim()
    if self.respond_to?(:tick)
      s=@state
      tick(@count)
      if @state!=s
        @count=0
      end
    else
      anim(@count)
    end
    @count+=1
  end
end
