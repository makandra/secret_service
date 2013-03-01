if defined?(ActiveRecord)
  require 'secret_service/database_store/active_record.rb'
else
  raise "Secret_service requires ActiveRecord at this time."
end
