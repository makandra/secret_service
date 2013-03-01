if defined?(ActiveRecord)
  require 'secret_service/database_store/active_record_store.rb'
else
  raise "Secret_service requires ActiveRecord at this time."
end
