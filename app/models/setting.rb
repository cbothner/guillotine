class Setting < ActiveRecord::Base
  KEYS = %w( dd_name dd_phone )

  KEYS.each do |key|
    define_singleton_method(key) do
      ivar = "@#{key}"
      return instance_variable_get(ivar) if instance_variable_defined?(ivar)
      instance_variable_set ivar, Setting.find_by_key(key).value
    end
  end

end
