module DataBridge
  class InternalObject

    def initialize params
      return unless params.kind_of?(Hash)
      @resource = params

      params.each do |key, value|
        self.inject_attribute(key, value)
      end
    end

    def inject_attribute attribute_name, value
      @resource[attribute_name.to_sym] = value
      singleton_class.class_eval { attr_accessor attribute_name }
      send("#{attribute_name}=", value)
    end

    def get_all
      return @resource
    end

    def get_all_except attrs = []
      return @resource.except(*attrs)
    end

    # dump class para permitir cache
    def marshal_dump; [@resource] end
    def marshal_load(data); initialize(*data) end

  end
end
