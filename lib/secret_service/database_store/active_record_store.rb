module SecretService
  module DatabaseStore
    class ActiveRecordStore
      TABLE_NAME = '_secret_service_secrets'

      class Secret < ::ActiveRecord::Base
        set_table_name TABLE_NAME
      end


      def initialize
        setup_database unless database_set_up?
      end

      def find(key)
        secret_record = find_if_present(key)
        unless secret_record
          new_secret = yield
          begin
            secret_record = Secret.create!(:key => key, :value => new_secret)
          rescue ::ActiveRecord::StatementInvalid
            # concurrency issue, someone else won
            secret_record = find_if_present(key)
          end
        end
        secret_record.value
      end

      private

      def setup_database
        Secret.connection.create_table TABLE_NAME do |table|
          table.string :key
          table.string :value
          table.timestamps
        end
        Secret.connection.add_index TABLE_NAME, :key, :unique => true
      rescue ::ActiveRecord::StatementInvalid
        # concurrency issue, can be ignored
      end

      def database_set_up?
        Secret.table_exists?
      end

      def find_if_present(key)
        Secret.first(:conditions => {:key => key})
      end
    end


    def self.get
      ActiveRecordStore.new
    end
  end
end
