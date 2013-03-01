module SecretService
  module DatabaseStore
    class ActiveRecordStore
      TABLE_NAME = '_secret_service_secrets'

      class Secret < ::ActiveRecord::Base
        if respond_to? :table_name=
          self.table_name = TABLE_NAME
        else
          set_table_name TABLE_NAME
        end
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
            secret_record = find_if_present(key)
          end
        end
        secret_record.value
      end

      def drop_database
        # tests need this
        Secret.connection.drop_table TABLE_NAME
        Secret.reset_column_information
      rescue ::ActiveRecord::StatementInvalid
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
