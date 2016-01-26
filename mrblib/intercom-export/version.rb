module IntercomExport
  class Version
    VERSION = "0.0.1"

    def initialize(output_io)
      @output_io = output_io
    end

    def run
      @output_io.puts "intercom-export version #{VERSION}"
    end
  end
end
