module ActiveMerchant
  module Billing
    module EbanxV2
      attr_accessor :gateway_version

      def get_gateway_version(parameters)
        return unless test?

        headers = { 'x-ebanx-client-user-agent': "ActiveMerchant/#{ActiveMerchant::VERSION}" }
        headers['authorization'] = @options[:integration_key]

        processing_type = parameters[:processing_type]

        add_processing_type_to_commit_headers(headers, processing_type) if processing_type == 'local'

        response = parse(ssl_get(get_url(test?), headers))

        @gateway_version = response['gateway'] || 'v1'
      end

      def headers(params)
        return unless @gateway_version == 'v2'

        headers['authorization'] = @options[:integration_key].to_s
      end
    end
  end
end