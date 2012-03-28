module OmniAuth
  module Strategies
    class Facebook < OAuth2

      MOBILE_USER_AGENTS =  'webos|ipod|iphone|mobile|android'

      def request_phase
        options[:scope] ||= "email,offline_access"
        options[:display] = mobile_request? ? 'touch' : 'page'
#        options[:authorize_params] = mobile_request? ? { :display => 'touch' } : { :display => 'page' }
        super
      end

      def mobile_request?
        ua = Rack::Request.new(@env).user_agent.to_s
        ua.downcase =~ Regexp.new(MOBILE_USER_AGENTS)
      end

    end
  end
end