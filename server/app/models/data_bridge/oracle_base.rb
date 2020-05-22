require 'oci8'

module DataBridge
  class OracleBase < DataBridge::Base

    def initialize
      @client = OCI8.new(self.connection_data)
    end

    protected
    def load_by_query query
      self.raw_data = []
      @client.exec(query) do |result|
        self.raw_data << result
      end

      if block_given?
        self.raw_data = yield(self.raw_data)
      end

      process_data
    end

    def process_data
      self.data = self.raw_data
    end

    def valid_data?
      self.data.count > 0
    end

    def run_query query
      @client.exec(query)
    end

    def close_connection!
      @client.logoff
    end

  end
end
