require "scrawls/ioengine/single/version"
require 'socket'
require 'mime-types'

module Scrawls
  module Ioengine
    class Single < Scrawls::Ioengine::Base

      def initialize(scrawls)
        @scrawls = scrawls
      end

      def run( config = {} )
        host = config[:host] || '127.0.0.1'
        port = config[:port] || '8080'
        server = TCPServer.new( host, port )

        while @connection = server.accept
          request = get_request @connection
          response = handle request

          close
        end
      end

      def send_data data
        @connection.write data
      end

      def close
        @connection.close
      end

      def get_request connection
        http_engine_instance = @scrawls.http_engine.new @scrawls
        r = ''
        while !http_engine_instance.done?
          line = connection.gets
          break if line.nil?
          http_engine_instance.receive_data line
        end

        if http_engine_instance.done?
          http_engine_instance.env
        else
          # TODO: Some error handling
          nil
        end
      end

      def handle request
        if request
          @scrawls.process request, @connection
        else
          @scrawls.deliver_400 @connection
        end
      end

    end
  end
end
