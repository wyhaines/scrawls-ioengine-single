module Scrawls
  module Ioengine
    class Single < Scrawls::Ioengine::Base

      def cork_tcp_socket( socket )
        begin
          socket.setsockopt( 6, 3, 1 ) if socket.kind_of? TCPSocket
        rescue IOError, SystemCallError
        end
      end

      def uncork_tcp_socket( socket )
        begin
          socket.setsockopt( 6, 3, 0 ) if socket.kind_of? TCPSocket
        rescue IOError, SystemCallError
        end
      end

    end
  end
end
