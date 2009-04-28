require 'mygame'
require 'mygame/scene'

include MyGame
create_screen
at_exit{ $! or MyGame.ran_main_loop? or MyGame.main_loop }
