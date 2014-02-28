# Creative Commons BY-SA :  Regis d'Aubarede <regis.aubarede@gmail.com>
class Geom
  PI=Math::PI
  def alimit(a)
      a -= 360 while a > 360
      a += 360 while a < 0
      a
  end
  def cos(a) Math.cos((PI*a)/180.0) end
  def sin(a) Math.sin((PI*a)/180.0) end
  def atan2(dy0,dx0) rd2deg(Math.atan2(dy0,dx0)) end
  def deg2rd(a) (PI*a)/180.0 end
  def rd2deg(a) (180.0*a)/PI end
  def crop(min,a,max)
     return min if a<min
     return max if a>max
     a
  end
  def inline?(t,epsilon)
      dx,dy=t.x-x, t.y-y
      h=Math.sqrt(dx*dx+dy*dy)
      b=atan2(dy,dx)
      aa=alimit(b-@cradar)
      dist= (h*sin(aa)).abs
      is=(dist<epsilon)&& aa<90
      p({:ee => self.class, :atan2 => b, :adiff => aa}) if is && self.kind_of?(T)
      is
  end
end

class Mobile < Geom
  attr_accessor :x,:y,:cdir,:cradar,:a
  def tank?() false end
  def obstacle?() false end  
  def initialize(x,y,coul="#AA0000")
    @x,@y,@dx,@dy,@coul=x,y,0,0,coul
    @count,@v,@a,@cdir,@cradar=0,0,0,0,0
    @state=""
  end
  def draw(w,cr)
      w.draw_rectangle(x-5,y-5,10,10,0,@coul,@coul) 
  end
  
  ######################## Movement ##################
  
  def intersect(other)
    ( (x-other.x)*(x-other.x)+ (y-other.y)*(y-other.y) ) < 8*8
  end
  def accelerate(c) @v= @v.abs<1 ? 1 : @v*=c end
  def pivot_by(c)   @a=alimit(@a+c)          end  
  def turn(c) 
     @a=alimit(@a+c)
     @cdir=alimit(@cdir+c)
     @cradar=alimit(@cradar+c)
  end
  def turn_to(a)
     da=alimit(a-@a)
     @cdir+= da
     @cradar+= da
     @a=a
  end
  def mindist?()
     x<5 || y<5 || x>($W-5) || y>($H-5)
  end
  def to_state(s)
    @state=s ? "_"+s.to_s : ""
    Message.alert("State unknown #{s} in class #{self.class}") unless self.respond_to?("tick#{@state}")
  end
  def dead() end
  def move()
    nx= @x+@v*cos(@a)/10
    ny=@y+@v*sin(@a)/10
    @x= crop(0,nx,$W)
    @y= crop(0, ny,$H)
    if $app.obstacle?(self)
      @v=-@v
    end
    @v=0 if nx!=@x || ny!=@y
  end
  
  ######################### Private  
  
  def childr?(t)      t==@parent end
  def pxy() 
    puts " #{@coul}: @ %4f/%4f v=%4f}/%4f  dir=#{@a} canon=#{@cdir} radar=#{@cradar} #{self.class.to_s}" % [@x,@y,@dx,@dy]
  end
  
  
  def _anim()
    if self.respond_to?(:tick)
      s=@state
      send("tick#{@state}",@count)
      if @state!=s
        @count=0
      end
    else
      anim(@count)
    end
    @count+=1
  end
end
