module IntercomExport
  class CLI
    API_URL = "api.intercom.io"
    SUPPORTED_RESOURCES = [
      "conversations"
    ]

    def initialize(argv, output_io = $stdout, error_io = $stderr)
      @options = setup_options
      @opts = @options.parse(argv)
      @output_io = output_io
      @error_io  = error_io
    end

    def run
      if @options.option(:version)
        Version.new(@output_io).run
      elsif @options.option(:help)
        Help.new(@output_io).run
      else
        token = @options.option(:token)
        exit_on_error "Token is missing" unless token

        key, secret = token.split(":")
        exit_on_error "Token format is incorrect" if key.nil? || secret.nil? || key.empty? || secret.empty?

        resource = @options.option(:resource)
        exit_on_error "No resource given" unless resource
        exit_on_error "Incorrect resource" unless SUPPORTED_RESOURCES.include? resource

        http = HttpRequest.new()

        @output_io.puts http.get(
          url(resource),
          nil,
          {
            "Accept" => "application/json",
            "Authorization" => "Basic #{Base64::encode(token)}"
          }
        ).body
      end
    end

    private
    def setup_options
      options = Options.new
      options.add(Option.new("token", "t", true))
      options.add(Option.new("resource", "r", true))
      options.add(Option.new("version", "v"))
      options.add(Option.new("help", "h"))

      options
    end

    def exit_on_error(message, code = 1)
      @error_io.puts message
      exit code
    end

    def url(resource)
      "https://#{API_URL}/#{resource}"
    end
  end
end
