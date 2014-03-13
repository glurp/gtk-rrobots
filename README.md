Rrobots
=======

rrobots game like (api not strikly compatible)

based on gtk (by Ruiby)


API
===

class template
-----
    class MyThank < Tank
     ....
     def tick(time)
        ..use thank api..
     end
     def tick_foo(time)   # called when state==foo
        ....
     end
    end
    MyThank  # !!! Indispensable !!!

api
---

    @cdir   cannon direction
    @cradar radar direction
    @a      thank move direction
    x,y     thank position
    @v      thank speed

    pivot_by(delta_direction)    # change moving, direction dont'move cannon & radar direction
    turn(delta_direction)        # change moving direction with cannon and radar direction
    turn_radar(delta_direction)  # change radar direction
    turn_cannon(delta_direction) # change cannon direction
    mindist?                     # true if game border is reach
    fire_good?                   # true if there are (other familly) thank in radar direction
    move                         # apply speed to thank position
    fire                         # true fire a bullet, 6 max bullet can be active from une thank
    count_bullet                 # number of active bullet (bullet fired by thank an not yet dead)
    accelerate(dv)
    tir(condition, state: cible) { action } # move to state name if condition is true
                                          tick_<@state> wille be call next tick


thank commented
---------------

    class T < Tank
     def initialize(x,y,coul="#FFAABB") 
        super(x,y,coul) ; 
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
end game is not well detected !
@var should not be directly read/modified                                      

