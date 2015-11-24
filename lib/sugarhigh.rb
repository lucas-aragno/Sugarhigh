require "sugarhigh/version"
require "httparty"

module Sugarhigh
    class Client
    include HTTParty

    attr_accessor :headers, :refresh_token

    def initialize(uri = '')
      @headers = {}
      @refresh_token = ''
      set_uri uri
    end

    def set_uri(uri)
      self.class.base_uri uri
    end

    def connect(params)
      response = do_request :post, '/oauth2/token', params
      add_header('OAuth-Token', response['access_token'])
      @refresh_token = response['refresh_token']
    end

    def create(resource, params)
      do_request :post, url_for_resource(resource), params
    end

    def get(resource, resource_id)
      do_request :get,  url_for_resource(resource) << resource_id
    end

    def update(resource, resource_id, params)
      do_request :put,  url_for_resource(resource) << resource_id
    end

    def delete(resource, resource_id)
      do_request :delete,  url_for_resource(resource) << resource_id
    end

    def get_all(resource, params)
      do_request :get,  url_for_resource(resource), params
    end

    def get_recent(params)
      do_request :get,   url_for_resource(resource), params
    end
    
    private

    def add_header(key, header)
      self.headers[key] = header
    end

    def url_for_resource(resource)
      case resource
      when :account then '/Accounts/'
      when :contact then '/Contacts/'
      when :opportunity then '/Opportunities/'
      when :report then '/Reports/'
      when :emails then '/Emails/'
      when :lead then '/Leads/'
      end
    end

    def do_request(method = :get, url = '', params = {})
       req_params = method == :get ? { :headers => @headers, :query => params } : { :headers => @headers, :body => params }
       self.class.send(method, url, req_params).parsed_response
    end
  end
end
