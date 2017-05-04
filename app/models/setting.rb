class Setting < ActiveRecord::Base
  KEYS = %w( dd_name dd_phone )

  KEYS.each do |key|
    define_singleton_method(key) do
      Setting.find_by_key(key).value
    end
  end

end
