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

        response = parse(ssl_get(get_url, headers))

        @gateway_version = response['gateway'] || 'v1'
      end

      def get_url
        if test?
          'https://sandbox.ebanxpay.com/channels/spreedly/flow'
        else
          'https://api.ebanxpay.com/channels/spreedly/flow'
        end
      end

      def headers(params)
        return {} unless @gateway_version == 'v2'

        commit_headers = {}
        commit_headers['authorization'] = @options[:integration_key].to_s
        commit_headers['content-type'] = "application/json"
        commit_headers
      end
    end
  end
end