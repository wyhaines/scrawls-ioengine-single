module Scrawls
  module Ioengine
    class Single < Scrawls::Ioengine::Base

      def cork_tcp_socket( socket )
        #NOP
      end

      def uncork_tcp_socket( socket )
        #NOP
      end

    end
  end
end

