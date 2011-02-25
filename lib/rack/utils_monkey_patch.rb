module Rack
  module Utils
    def escape(s)
      s.to_s.dup.force_encoding("utf-8").gsub(/([^ a-zA-Z0-9_.-]+)/u) {
        '%'+$1.unpack('H2'*bytesize($1)).join('%').upcase
      }.tr(' ', '+')
    end
  end
end