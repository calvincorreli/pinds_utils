module PindsUtils
  class Enumeration  
    include Comparable

    def self.names() end
    def self.labels() end
  
    def initialize(index)
      unless @index = self.class.names.index(index)
        raise "Illegal value '#{index}'" unless (index.is_a?(String) ? index =~ /^[0-9]+$/ : index.respond_to?(:to_i))
        @index = index.to_i
      end
      freeze
    end
  
    def index
      @index
    end
  
    def name
      self.class.names[@index]
    end
  
    def to_s
      self.class.labels[@index]
    end
    alias label :to_s
    
    def to_i
      @index
    end
    
    def inspect
      "#{self.class.name}: #{to_s} (#{name} / #{to_i})"
    end
  
    def to_sym
      self.class.names[@index].to_sym
    end
  
    def <=>(other)
      @index <=> other.to_i
    end
  
    # Lets you use Enumeration.collection with options_for_select
    def first
      to_s
    end
    def last
      name
    end
    
    def to_option
      [first, last]
    end

    # Lets this be used as the key in a hash
    def eql?(other)
      other.is_a?(self.class) && other.index == index
    end  
    def hash
      index.hash
    end

    def method_missing(sym, *args, &block)
      if sym.to_s =~ /^(.*)\?$/ && index = self.class.names.index($1)
        self.index == index
      else
        super
      end
    end

    class <<self
      def collection
        (0...names.size).collect { |index| new index }
      end

      def method_missing(sym, *args, &block)
        names.index(sym.to_s) ? self[sym] : super
      end
    
      def [](value)
        new(value.to_s)
      end
    end
  end
end