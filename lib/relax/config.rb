module Relax
  class Config
    def self.build(parameters)
      Class.new do
        parameters.each do |name, options|
          attr name, true

          if default = options[:default]
            define_method(name) do
              if instance_variables.include?("@#{name}")
                instance_variable_get("@#{name}")
              else
                instance_variable_set("@#{name}", default)
              end
            end
          end
        end
      end.new
    end
  end
end
