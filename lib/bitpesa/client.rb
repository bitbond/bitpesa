require "securerandom"
require "net/http"
require "json"
require "uri"

module BitPesa

  class Client

    @host     = "api.bitpesa.co"
    @key      = "API key"
    @secret   = "API secret"
    @base_url = "/v1"
    @timeout  = 5
    @debug    = false

    class << self

      attr_accessor :host, :key, :secret, :timeout, :debug
      attr_reader   :base_url

      def get(endpoint, payload=nil)
        url = request_url(endpoint)
        query_string = payload && payload.reduce([]) {|r,item| r << item[1].to_query(item[0])}.join("&")
        url += "?" + query_string if query_string
        request "GET", url
      end

      def post(endpoint, payload={})
        body = JSON.generate(payload)
        request "POST", request_url(endpoint), body
      end

      def put(endpoint, payload={})
        body = JSON.generate(payload)
        request "PUT", request_url(endpoint), body
      end

      def patch(endpoint, payload={})
        body = JSON.generate(payload)
        request "PATCH", request_url(endpoint), body
      end

      def delete(endpoint)
        request "DELETE", request_url(endpoint)
      end

      private

        def request_url endpoint
          base_url + endpoint
        end

        def generate_nonce
          SecureRandom.uuid
        end

        def sign *args
          message = args.compact.join("&")
          OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA512.new, secret, message)
        end

        def request http_method, url, payload=nil
          req = Net::HTTP.const_get(http_method.capitalize).new(url, headers(http_method, url, payload))
          req.body = payload
          handle connection.start{|h| h.request(req)}
        end

        def headers http_method, url, body
          nonce = generate_nonce
          full_url = "https://" + host + url
          body_hexdigest = OpenSSL::Digest::SHA512.hexdigest(body || "")
          {
            "Content-Type" => "application/json",
            "Accept" => "text/html",
            "User-Agent" => "BitPesa Ruby API Client",
            "Authorization-Nonce" => nonce,
            "Authorization-Key" => key,
            "Authorization-Signature" => sign(nonce, http_method, full_url, body_hexdigest)
          }
        end

        def connection
          connection = Net::HTTP.new(host, 443)
          connection.open_timeout = timeout
          connection.read_timeout = timeout
          connection.use_ssl = true
          connection.set_debug_output($stderr) if debug
          connection
        end

        def handle response
          case response
            when Net::HTTPSuccess
              (response.body != "" && JSON.parse(response.body)) || true
            when Net::HTTPUnauthorized
              raise BitPesa::Unauthorized.new ""
            else
              raise BitPesa::Error.new response.body
          end
        end

    end

  end
end
