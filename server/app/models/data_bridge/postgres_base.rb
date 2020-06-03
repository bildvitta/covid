# require 'mysql2'

module DataBridge
  class PostgresBase < DataBridge::Base
    attr_accessor :raw_data, :data

    def initialize
      @client = PG.connect(self.connection_data)
    end

    protected
    def load_by_query query
      self.raw_data = @client.exec(query)

      if block_given?
        self.raw_data = yield(self.raw_data)
      end

      process_data
    end

    def process_data
      self.data = self.raw_data.to_a
    end

    def valid_data?
      self.data.count > 0
    end

    def run_query query
      @client.query(query)
    end

    def close_connection!
      @client.close
    end

  end
end
