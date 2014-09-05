require 'stringio'

module RailsWebConsole
  class ConsoleController < ::ActionController::Base
    skip_before_action :verify_authenticity_token
    layout false

    def index
    end

    def run
      command = params[:script]

      stdout = ''
      stdout_orig = $stdout
      $stdout = StringIO.new
      begin
        if command[0, 5] == 'rake '
          result = rake(command[5, command.length])
        else
          result = eval command, binding
        end
        $stdout.rewind
        stdout = 'error during stdout capture'
        stdout = escape $stdout.read
      rescue
        result = $!
      rescue SyntaxError => e
        result = e
      end
      $stdout = stdout_orig
      render(json: {
        stdout: stdout,
        value: escape(result.to_s),
        type: get_type(result)
      })
    end

    protected

      # invoke rake task from here
      def rake task
        unless @tasks_loaded
          require 'rake'
          Rails.application.load_tasks
          @tasks_loaded = true
        end
        Rake::Task[task].execute
        nil
      end

    private

    TYPES = [
      Exception, Numeric, String
    ]

    def get_type(result)
      for type in TYPES
        if result.is_a? type
          return type.name
        end
      end
      result.class.name        
    end

    def escape(content)
      view_context.escape_once content
    end
  end
end
