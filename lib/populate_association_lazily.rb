# Allows creation of objects through associations by assigning hash to association
#
#   class User < ActiveRecord::Base
#     has_one :wristband
#   end
#   class Wristband < ActiveRecord::Base
#   end
#
#   user = User.new(:wristband => { :color => 'orange' })
#
module PopulateAssociationLazily
  module PopulateSingleAssocationLazily
    def self.included base_class
      base_class.class_eval do
        def replace_with_populate_from_hash *args
          obj = args.shift
          new_obj = obj.kind_of?(Hash) ? new_record(true) { |klass| klass.new(obj) } : obj
          new_obj = new_obj ? new_obj : proxy_reflection.klass.new(obj)
          replace_without_populate_from_hash *args.unshift(new_obj)
        end
        alias_method_chain :replace, :populate_from_hash
      end
    end
  end

  module PopulateMultipleAssociationLazily
    def self.included base_class
      base_class.class_eval do
        def replace_with_populate_from_hash other_array
          new_array = other_array.map do |attributes|
            attributes.kind_of?(Hash) ? @reflection.klass.new(attributes) : attributes
          end
          replace_without_populate_from_hash new_array
        end
        alias_method_chain :replace, :populate_from_hash
      end
    end
  end

  module PopulateBelongsToPolymorphicAssociationLazily
    def self.included base_class
      base_class.class_eval do
        def replace_with_populate_from_hash attributes
          if attributes.kind_of?(Hash)
            raise ArgumentError, 'You must specify a valid class name as the type of the record to be created' unless attributes[:type]
            klass = attributes[:type].constantize
            record = klass.new(attributes)
          else
            record = attributes
          end
          replace_without_populate_from_hash record
        end
        alias_method_chain :replace, :populate_from_hash
      end
    end
  end

end
