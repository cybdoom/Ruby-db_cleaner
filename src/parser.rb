# Parses responses from the remote server
module Parser

  # html parser
  module HTML

    def parse_keys html
      # STUB
      html
    end

    def parse_tokens html
      # STUB
      html
    end

  end

  # json parser
  module JSON
    require 'json'

    def parse_keys json_str
      # STUB
      ::JSON.parse json_str
    end

    def parse_tokens json_str
      # STUB
      ::JSON.parse json_str
    end

  end

end
