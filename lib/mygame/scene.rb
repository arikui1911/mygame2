require 'mygame'

module MyGame
  module Scene
    def self.main_loop(scene_class, fps = 60, step = 1)
      MyGame.create_screen
      scene = scene_class.new
      scene.init
      base_step = step
      alist = [[Key::PAGEDOWN, +1], [Key::PAGEUP, -1]]
      MyGame.main_loop(fps) do
        step += (v = alist.inject(0){|r, (key, d)| r + (MyGame.new_key_pressed?(key) ? d : 0) })
        MyGame.fps = fps * base_step / step unless v == 0
        step.times do
          break if scene.next_scene
          scene.update
          Base::FRAME_COUNTERS[scene] += 1
        end
        scene.render
        if scene.next_scene
          scene.quit
          MyGame.init_events
          [Font, Image, Wave].each{|c| c.cache.clear }
          break if Exit == scene.next_scene
          scene = scene.next_scene.new
          scene.init
        end
      end
    end
    
    class Exit
      ;
    end
    
    class Base
      FRAME_COUNTERS = Hash.new(0)
      
      def frame_counter
        Base::FRAME_COUNTERS[self]
      end
      
      attr_accessor :next_scene
      
      def init
        ;
      end
      
      def quit
        ;
      end
      
      def update
        ;
      end
      
      def render
        ;
      end
    end
  end
end
