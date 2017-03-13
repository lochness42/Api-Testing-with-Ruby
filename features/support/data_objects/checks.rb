class Checks
  def no_nils?
    result = true
    self.instance_variables.each { |variable|
      result = result && !self.instance_variable_get(variable).nil?
    }
    result
  end

  def nils
    result = []
    self.instance_variables.each { |variable|
      result << variable if self.instance_variable_get(variable).nil?
    }
    result
  end

  def different(other_object, ignore=nil)
    result             = []
    instance_variables = self.instance_variables
    if !ignore.nil?
      instance_variables.reject! { |variable|
        ignore.include?(variable.to_s)
      }
    end
    instance_variables.each { |variable|
      this_object_variable_value  = self.instance_variable_get(variable)
      other_object_variable_value = other_object.instance_variable_get(variable)
      if this_object_variable_value != other_object_variable_value
        result << { variable => [this_object_variable_value, other_object_variable_value] }
      end
    }
    result
  end
end
