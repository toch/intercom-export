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
      @http_request = HttpRequest.new()
      @token = ""
    end

    def run
      if @options.option(:version)
        Version.new(@output_io).run
      elsif @options.option(:help)
        Help.new(@output_io).run
      else
        @token = @options.option(:token)
        exit_on_error "Token is missing" unless @token

        key, secret = @token.split(":")
        exit_on_error "Token format is incorrect" if key.nil? || secret.nil? || key.empty? || secret.empty?

        resource = @options.option(:resource)
        exit_on_error "No resource given" unless resource
        exit_on_error "Incorrect resource" unless SUPPORTED_RESOURCES.include? resource

        conversations = []

        url_page = url(resource, nil, {"per_page" => 50})

        loop do
          response = get url_page

          response["conversations"].each do |conversation|
            conversations << conversation
          end

          break if response["pages"].nil? || response["pages"]["next"].nil? || response["pages"]["next"].empty?
          url_page = response["pages"]["next"]
        end

        conversations.each do |conversation|
          response = get url(resource, conversation["id"])
          message = response["conversation_message"]

          author = get_author(message["author"]["type"], message["author"]["id"])

          @output_io.puts format_message(
            conversation["open"],
            conversation["created_at"],
            message["subject"],
            author["name"],
            author["email"],
            message["body"]
          )

          response["conversation_parts"]["conversation_parts"].each do |conversation_part|
            author = get_author(conversation_part["author"]["type"], conversation_part["author"]["id"])

            @output_io.puts format_message(
              nil,
              conversation_part["created_at"],
              nil,
              author["name"],
              author["email"],
              conversation_part["body"]
            )
          end

          @output_io.puts "\#" * 10
        end
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

    def url(resource, id = nil, params = nil)
      str = "https://#{API_URL}/#{resource}"
      str << "/#{id}" if id
      str << "?" if params
      str << params.map do |param, value|
        param_str = "#{param}"
        param_str << "=#{value}" unless value.nil?
        param_str
      end.join("&") if params
      str
    end

    def get(url)
      JSON::parse @http_request.get(
        url,
        nil,
        {
          "Accept" => "application/json",
          "Authorization" => "Basic #{Base64::encode(@token)}"
        }
      ).body
    end

    def get_author(type, id)
      if ["admin", "team"].include? type
        admins = get url("admins")
        admin = admins["admins"].select{ |admin| admin["id"].to_i == id.to_i }.first
        return { "name" => "", "email" => "" } unless admin
        return { "name" => admin["name"], "email" => admin["email"] }
      end
      get url("users", id)
    end

    def format_message(status, timestamp, subject, from_name, from_email, body)
      str = ""
      str << "Status: #{status ? "open" : "close"}\n" unless status.nil?
      str << "Subject: #{subject}\n" if subject
      str << "Date: #{Time.at(timestamp.to_f).utc.to_s}\n" if timestamp
      str << "From: #{from_name} <#{from_email}>\n"
      str << "Body:\n" if body
      str << body if body
      str << "\n"
      str << "-" * 10
    end
  end
end
