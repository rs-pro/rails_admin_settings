module RailsAdminSettings
  # we are inheriting from BasicObject so we don't get a bunch of methods from
  # Kernel or Object
  class Fallback < BasicObject
    def initialize(ns, fb)
      @ns = ns
      @fb = fb
    end

    def inspect
      "#<RailsAdminSettings::Fallback ns: #{@ns.inspect}, fb: #{@fb.inspect}>"
    end

    def method_missing(*args)
      @ns.ns_mutex.synchronize do
        @ns.fallback = @fb
        @ns.__send__(*args)
      end
    end
  end
end
