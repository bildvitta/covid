module DataBridge
  class WebServiceBase < DataBridge::Base

    protected
    def request_api path, params = {}, payload = {}, headers = {}, options = {}
      options = { http_method: :post, payload_processor: :to_json }.merge(options)
      print "POST #{filter_address(get_address(path, params), params)}..."

      if Rails.env.development?
        puts "\nPayload: " + ('-' * 50)
        puts JSON.pretty_generate(payload)
      end

      begin
        self.raw_data = RestClient::Request.execute(
          method: options[:http_method], url: get_address(path, params), payload: payload.try(options[:payload_processor]),
          headers: { 'Content-Type' => 'application/json' }.merge(headers)
        )
      rescue => e
        puts " [ ERROR ]"
        Rails.logger.fatal("Error to post data: #{e.message}")
        self.raw_data, self.data = 0, nil
      end
      puts " [ DONE ]"

      if block_given?
        self.raw_data = yield(self.raw_data)
      end

      process_json
      self.raw_data = nil if self.raw_data != 0
    end

    def process_json
      return unless self.raw_data.kind_of?(String)
      self.data = JSON.parse(self.raw_data)

      if Rails.env.development?
        puts 'Response: ' + ('-' * 50)
        puts JSON.pretty_generate(self.data)
      end
    end

    def url_encode data
      CGI::escape(data.to_s)
    end

    def valid_data?
      !self.data.blank?
    end

    def dynamic_get api_path, params, request_mapping, response_mapping, single_result = false
      params = self.default_params(params, request_mapping)

      self.api_get(api_path, params)
      self.dynamic_process_results(response_mapping)

      self.data = nil if Rails.env.production?
      return single_result ? self.results.try(:first) : self.results
    end

    def default_params params = {}, keys = []
      keys.map{ |key| [key.to_sym, (params.has_key?(key.to_sym) ? params[key.to_sym] : '')] }.to_h
    end

    def get_address path, params = {}
      params = {} unless params.kind_of?(Hash)
      return "#{get_host}#{path}" + (params.empty? ? '' : '?') + params.to_query
    end

    def filter_address address, params = {}
      return address if Rails.env.development?

      %w(password).each do |filterable|
        address.gsub!(params[filterable.to_sym], '[FILTERED]') if params.has_key?(filterable.to_sym)
      end

      return address
    end

    def get_host
      port = (!connection_data[:port].blank? && ![80, 443].include?(connection_data[:port]) ? ":#{connection_data[:port]}" : '')

      return "http#{(connection_data[:use_ssl] ? 's' : '')}://#{connection_data[:hostname]}#{port}#{connection_data[:base_path]}"
    end

  end
end
