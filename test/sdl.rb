module SDL
  INIT_AUDIO = 1
  INIT_VIDEO = 2
  
  module Key
    def self.scan
    end
  end
  
  module Event2
    def self.const_missing(name)
      const_set name, "#{self.name}::#{name}"
    end
    
    def self.poll_queue
      @poll_queue ||= []
    end
    
    def self.poll
      poll_queue.shift
    end
  end
  
  class CollisionMap
    def self.bounding_box_check(*args)
      args
    end
  end
  
  module Mixer
    def self.play_channel(channel, data, n_loop)
      return channel, data, n_loop
    end
    
    def self.play_music(data, n_loop)
      return data, n_loop
    end
    
    def self.halt_music
      throw :sdl_mixer_halt_music
    end
    
    class Wave
      def self.load(filename)
        new(filename)
      end
      
      def initialize(filename)
        self.filename = filename
      end
      
      attr_accessor :filename
    end
    
    class Music < Wave
      ;
    end
  end
end

