module ActivePresenter
  class Base
    class_inheritable_accessor :presented
    self.presented = {}

    def self.presents(*types)
      attr_accessor *types
      
      types.each do |t|
        presented[t] = t.to_s.classify.constantize
      end
    end
    
    def initialize(args = {})
      presented.each do |type, klass|
        send("#{type}=", args[type].is_a?(klass) ? args.delete(type) : klass.new)
      end
      
      args.each { |k,v| send("#{k}=", v) }
    end
    
    def method_missing(method_name, *args, &block)
      presented_attribute?(method_name) ? delegate_message(method_name, *args, &block) : super
    end
    
    protected
      def delegate_message(method_name, *args, &block)
        presentable = presentable_for(method_name)
        send(presentable).send(flatten_attribute_name(method_name, presentable), *args, &block)
      end
      
      def presentable_for(method_name)
        presented.keys.detect do |type|
          method_name.to_s.starts_with?(attribute_prefix(type))
        end
      end
    
      def presented_attribute?(method_name)
        !presentable_for(method_name).nil?
      end
      
      def flatten_attribute_name(name, type)
        name.to_s.delete(attribute_prefix(type))
      end
      
      def attribute_prefix(type)
        "#{type}_"
      end
  end
end
