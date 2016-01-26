module IntercomExport
  class Help
    def initialize(output_io)
      @output_io = output_io
    end

    def run
      @output_io.puts "intercom-export [switches] [arguments]"
      @output_io.puts "intercom-export -r, --resource           : export a resource (supported: conversations)"
      @output_io.puts "intercom-export -t, --token              : Intercom API Key and Secret (required)"
      @output_io.puts "intercom-export -h, --help               : show this message"
      @output_io.puts "intercom-export -v, --version            : print intercom-export version"
    end
  end
end
