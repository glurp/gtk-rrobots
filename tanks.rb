# Creative Commons BY-SA :  Regis d'Aubarede <regis.aubarede@gmail.com>

class TankGamer < Tank ; end

class TankManuel < TankGamer

  def initialize(x,y,coul="#FF0000") super(x,y,coul) ; end
  def anim(c)
    turn_radar(Math::PI/360)
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
     #turn_radar(0.5*Math::PI/360)
     turn_to(Math::PI/16.0)
     move()
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
     turn_radar(0.5*Math::PI/360)
     turn(Math::PI/260.0)
     move()
     if  fire_good?
       @cdir+=(@cradar-@cdir)/2
       @cible=@cradar
     end
     fire if (@cible-@cdir).abs<0.05
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
     #turn_radar(0.5*Math::PI/360)
     turn_to(Math::PI/16.0)
     move()
  end
end