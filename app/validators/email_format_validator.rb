 class EmailFormatValidator < ActiveModel::EachValidator  
      def validate_each(object, attribute, value)  
        unless value =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i  #/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i  
          object.errors[attribute] << (options[:message] || "is not formatted properly")  
        end  
      end  
 end  