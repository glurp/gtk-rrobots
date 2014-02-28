# Creative Commons BY-SA :  Regis d'Aubarede <regis.aubarede@gmail.com>

class TankGamer < Tank ; end
class TankGenie < TankGamer
 def initialize(x,y,coul="#9999FF") 
    super(x,y,coul) ; 
    @v,@cradar,@cible,@tc= 11,0,-400,9999999
    @s=1
    turn(rand(360))
  end
  def tank?() true end
  def common
     pivot_by(45) if mindist?
     turn_radar(@s*2)
     @cdir=@cradar-@s*0.1*(-1)
     turn_cannon(1)
     if fire_good?
		@cible=@cradar
     end
     move()
  end
  def tick(c)
     common
     tir((@cible-@cdir).abs<2,state: :a) { @v*=-1; fire }
  end
  def tick_a(c)
    common
    fire if c%3==0
    tir( (@cible-@cdir).abs>3,state: :b) do
       @cible=999999999
       @v=11
    end
  end
  def tick_b(c)
    common
    fire if c%3==0
    tir( c>6,state: nil) do
        @s *= -1
        @v=11
    end
  end
end

class TankEvil < TankGamer
 def initialize(x,y,coul="#FFAABB") 
    super(x,y,coul) ; 
    @v= 8
    @cradar=0
    @cible=-1
    turn(rand(100))
  end
  def tank?() true end
  def anim(c)
     pivot_by(rand(45)) if mindist?
     turn_radar(0.25)
     turn(0.5)
     move()
     if  fire_good?
       @cdir=(@cradar+@cdir)/2
       @cible=@cradar
     end
     fire if (@cible-@cdir).abs<1
  end
end

class TankManuel < TankGamer

  def initialize(x,y,coul="#FF0000") super(x,y,coul) ; end
  def anim(c)
    turn_radar(1)
    accelerate(0.95)
    move()
  end
  def tank?() true end
end

class TankDuck < TankGamer
  def initialize(x,y,coul="#FF4444") 
    super(x,y,coul) ; 
    @v= 3
    @cradar=0
  end
  def tank?() true end
  def anim(c)
     turn_to(4)
     move()
  end
end


class TankDuck3 < TankGamer
  def initialize(x,y,coul="#44FF44") 
    super(x,y,coul) ; 
    @v= 3
    @cradar=0
  end
  def tank?() true end
  def anim(c)
     turn_to(4)
     move()
  end
end