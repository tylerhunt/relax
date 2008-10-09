require 'openssl'
require 'net/https'
require 'uri'
require 'date'
require 'base64'
require 'erb'

module Relax
  # Service is the starting point for any REST consumer written with Relax. It
  # is responsible for setting up the endpoint for the service, and issuing the
  # HTTP requests for each call made.
  #
  # == Extending Service
  #
  # When writing consumers, you should start by extending Service by inheriting
  # from it and calling its constructor with the endpoint for the service.
  #
  # === Example
  #
  #   class Service < Relax::Service
  #     ENDPOINT = 'http://example.com/services/rest/'
  #
  #     def initialize
  #       super(ENDPOINT)
  #     end
  #   end
  #
  # == Calling a Service
  #
  # Each call made to the service goes through the #call method of Service,
  # which takes in a Request object and a Response class. The Request object is
  # used to generate the query string that will be passed to the endpoint. The
  # Reponse class is instantiated with the body of the response from the HTTP
  # request.
  #
  # === Example
  #
  # This example show how to create a barebones call. This module can be then
  # included into your Service class.
  #
  #   module Search
  #     class SearchRequest < Relax::Request
  #     end
  #
  #     class SearchResponse < Relax::Response
  #     end
  #
  #     def search(options = {})
  #       call(SearchRequest.new(options), SearchResponse)
  #     end
  #   end
  #
  class Service
    attr_reader :endpoint

    # This constructor should be called from your Service with the endpoint URL
    # for the REST service.
    def initialize(endpoint)
      @endpoint = URI::parse(endpoint)
    end

    protected

    # Calls the service using a query built from the Request object passed in
    # as its first parameter. Once the response comes back from the service,
    # the body of the response is used to instantiate the response class, and
    # this response object is returned.
    def call(request, response_class)
      uri = @endpoint.clone
      uri.query = query(request).to_s
      response = request(uri)
      puts "Response:\n#{response.body}\n\n" if $DEBUG
      response_class.new(response.body)
    end

    private

    def default_query
      Query.new
    end

    def query(request)
      Query.new(default_query.merge(request.to_query))
    end

    def request(uri)
      puts "Request:\n#{uri.to_s}\n\n" if $DEBUG
      http = Net::HTTP.new(uri.host, uri.port)

      if uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      http.start do |http|
        request = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
        http.request(request)
      end
    end
  end
end
