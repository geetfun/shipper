# ShopscalerShipper
module ShopscalerShipper
  
  SHIPPING_OPTIONS = { 
                      1 => "flat_rate", 
                      2 => "weight_based", 
                      3 => "price_based"
                     }
  
  def self.included(base)
    base.extend Base
  end
  
  module Base
    def load_shopscaler_shipper
      unless included_modules.include? InstanceMethods
        include InstanceMethods
        extend ClassMethods
      end
    end
  end
  
  # Common methods to all
  module ClassMethods
    def shopscaler_shipper(options={})
      if options[:rate_type]
        module_name = options[:rate_type].camelize
        instance_eval %{ include Options::#{module_name} }
      else
        include Options::Default
      end
    end
  end
  
  # Instance methods to all
  module InstanceMethods
    # Lazy loads the specific shipping module
    def load_module(criteria_value)
      class_eval %{ shopscaler_shipper :rate_type => SHIPPING_OPTIONS[#{criteria_value}] }
    end
    
    def get_min_criteria(criteria_value)
      
    end
    
    def get_max_criteria(criteria_value)
      0
    end
    
    def get_rate_type(criteria_value)
      # rate_type is the attr_attribute in the Shipping Rate model 
      # It describes what type of shipping rate it is. Eg. Flat rate, weight based, etc
      # The argument, x, is the criteria type  
      SHIPPING_OPTIONS[criteria_value]
    end
    
  end  
    
end