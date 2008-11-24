module ValidatesExistenceOf
  
  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end
  
  module ClassMethods
    # Validates if the associated object exists in the database
    # Usage: validates_existence_of :ar_association
    # Supports only belongs_to associations
    def validates_existence_of(*attr_names)
      begin 
        default_message = I18n.translate('activerecord.errors.messages.invalid')
      rescue NameError
        default_message = ActiveRecord::Errors.default_error_messages[:invalid]
      end
      configuration = {
        :message => default_message,
        :on => :save
      }
      
      configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
      
      validates_each(attr_names, configuration) do |record, attr, value|
        reflection = record.class.reflect_on_association(attr)
        if !reflection.nil? && reflection.macro == :belongs_to
          if !reflection.options.has_key?(:polymorphic)
            c = eval(reflection.class_name, binding)
            obj = c.find(:first, :conditions => ["id = ?", record.send(reflection.primary_key_name)])
            record.errors.add(reflection.primary_key_name, configuration[:message]) if obj.nil?
          else
            # If this is a polymorphic association
            # We try to see if both polymorphic_type is present because we infer the class name from it.
            if !reflection.options[:foreign_type].blank? && !record.send(reflection.options[:foreign_type]).blank?
              c = eval(reflection.send(reflection.options[:foreign_type]), binding)
              obj = c.exists?(record.send(reflection.primary_key_name))
              record.errors.add(reflection.primary_key_name, configuration[:message]) if obj.nil?
            else
              record.errors.add(reflection.primary_key_name, configuration[:message])
            end
          end
        end
      end
    end
    
  end
  
end

class ActiveRecord::Base
  include ValidatesExistenceOf
end
