Rrobots
=======

rrobots game like (api not strikly compatible)

based on gtk (by Ruiby)


API
===

class template
-----
    class MyThank < Tank
     def tick(time)       # called when state==nill
        ..use thank api..
     end
     def tick_foo(time)   # called when state==foo
        ....use thank api.. 
     end
    end
    MyThank  # !!! Indispensable !!!

api
---
direction are in degree (0..360), positions are in pixel,speed in pixel/tick

    @cdir   cannon direction
    @cradar radar direction
    @a      thank move direction
    x,y     thank position
    @v      thank speed

    turn_radar(delta_direction)  # change radar direction
    turn_cannon(delta_direction) # change cannon direction
    
    pivot_by(delta_direction)    # change moving, direction dont'move cannon & radar direction
    turn(delta_direction)        # change moving direction with cannon and radar direction
    turn_to(direction)           # force current move direction
    mindist?                     # true if game border is reach
    move                         # apply speed to thank position/direction
    
    fire_good?                   # true if there are (other familly) thank in radar direction
    count_bullet                 # number of active bullet (bullet fired by thank and not yet dead)
    fire                         # fire a bullet, done if count_bullet() is less than 6
    
    accelerate(dv)
    tir(condition, state: cible) { action } # move to state name if condition is true
                                          tick_<@state> will be call next tick


thank commented
---------------

    class T < Tank
     def initialize(x,y,coul="#FFAABB") 
        super(x,y,coul) ;  # coul= fill color of thank, x/y : position
        @v= 8              # initial speed
        @cradar=0          # initial directions
        @cible=-1
        turn(rand(100))
      end
      def tick(c)                            # c is incremented on each call==> game time
         pivot_by(rand(45)) if mindist?      # turn if border reached
         turn_radar(0.25)                    # turn radar continuously
         turn(0.5)                           # turn tank
         move()                              
         if  fire_good?                      # radar detect a enemy
           @cdir=(@cradar+@cdir)/2           # turn cannon
           @cible=@cradar                    # memo enemy direction
         end
         fire if (@cible-@cdir).abs<1        # fire a bullet id cannon is in enemy direction
      end
    end
    T


                                          
bugs
----
end of game is not well detected !
@var should not be directly read/modified                                      

