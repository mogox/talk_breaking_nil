def publish_message(organization_id, user_id, message_body)
     learning_message = Trailhead::C2c::LearningMessage.new(
       message_body.fetch(:award_uid),
       Time.zone.parse(message_body.fetch(:earned_at)).to_datetime
     )
    c2c_client.notify_learning_event(
organization_id, 
user_id, 
learning_message
    )
  end


class C2C::HttpHelper
  def permission_request(url, jwt)
    p "=============== URL *** #{url}"
    p "=============== TIMEOUT *** #{timeout}"
    uri = URI.parse(url)
    Net::HTTP.start(uri.hostname, uri.port, read_timeout: timeout, use_ssl: true) do |http|
      p "=========  GETTING READY FOR REQUEST"
      request = Net::HTTP::Post.new(uri.request_uri)
      p "=========== REQUEST BUILD #{request}"
      request['authorization'] = "C2C #{jwt}"
      p "=========== set C2C header"
      http.request(request) # HERE IS THE ISSUE
    end
    rescue StandardError => re
      re.backtrace.join("\n")
      p re.class
      raise re
  end
end

module Net
  class HTTP < Protocol
    def request(req, body = nil, &block)  # :yield: +response+
      p "HTTP REQUEST"
      p "======== Before started"
      unless started?
        start {
          req['connection'] ||= 'close'
          return request(req, body, &block)
        }
      end
      p "================= after started? block"
      if proxy_user()
        req.proxy_basic_auth proxy_user(), proxy_pass() unless use_ssl?
      end
      p "========= proxy block"
      req.set_body_internal body
      res = transport_request(req, &block)
      p "=========  After transport_request"
      if sspi_auth?(res)
        sspi_auth(req)
        res = transport_request(req, &block)
      end
      p "========= after sppi auth?"
      res
    end
  end
end


def transport_request(req)
   begin
     begin_transport req
     res = catch(:response) {
       ...
         res = HTTPResponse.read_new(@socket)
       ... }
   rescue Net::OpenTimeout
     raise
   rescue Net::ReadTimeout, IOError, EOFError,
    ....
   end
   ...
 rescue => exception
   D "Conn close because of error #{exception}"
   @socket.close if @socket
   raise exception
 end
end


 def begin_transport(req)
      if @socket.closed?
        connect
      ...
  end

 def connect
      D "opening connection to #{conn_addr}:#{conn_port}..."
      s = Timeout.timeout(@open_timeout,  Net::OpenTimeout) {
             begin
          TCPSocket.open(conn_addr, conn_port, @local_host, @local_port)
        rescue => e
          raise e, "Failed to open TCP connection to " +
            "#{conn_addr}:#{conn_port} (#{e.message})"
        end
end


 def timeout(sec, klass = nil, message = nil)
    return yield(sec) if sec == nil or sec.zero?
      ...
      begin
        x = Thread.current
        y = Thread.start {
          Thread.current.name = from
          begin
            sleep sec
          rescue => e
            x.raise e
          end
    end
end

ENV['TIMEOUT_SECONDS']
=> nil

ENV['TIMEOUT_SECONDS'].to_s
=> ""

> sleep "10"
TypeError: can’t convert String into time interval

timeout = nil


### Verification
timeout_process = ENV['TIMEOUT_SECONDS']
# => nil
Timeout.timeout(timeout_process, Timeout::Error, "User message: the code took more time to run") { sleep 10; puts "this message should not be printed" }
this message should not be printed

Timeout.timeout(timeout, Timeout::Error, "User message: the code took more time to run") { sleep 10; puts "waiting for 10 seconds" }

### this is what I got:
def timeout(sec, klass = nil, message = nil, &block)   #:yield: +sec+
  return yield(sec) if sec == nil or sec.zero?


def development?
  @hostname == "staging" || @hostname == "production"
end

ENV["TIMEOUT_SECONDS"]
=> nil

timeout =  development? ?  DEFAULT_TIMEOUT : ENV['TIMEOUT_SECONDS'].to_s
=> ""

Timeout.timeout(timeout, Timeout::Error, "User message: the code took more time to run") { sleep 10; puts "waiting for 10 seconds" }
`timeout': undefined method `zero?' for an instance of String (NoMethodError)

