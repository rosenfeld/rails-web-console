require 'stringio'

module RailsWebConsole

  class Context
    def initialize
      @block = Proc.new {}
      @binding = binding
    end

    def run command
      eval command, @binding
    end

    def routes match = nil
      require 'terminal-table'
      rows = Rails.application.routes.routes.map do |r| 
        constraints = r.constraints.dup
        method = constraints.delete(:request_method).to_s.gsub(/[^A-Z\|]/, '').split('|').reverse.join(', ')
        # When TJ (maintainer of terminal-table) makes a new release, use the following line:
        #[r.name.to_s, {:value => method, :alignment => :right}, r.path.spec, constraints.inspect]
        [
          r.name.to_s, 
          method.rjust(12), 
          r.path.spec, 
          constraints == {} ? '' : constraints.inspect
        ]
      end

      if match
        rows.select! { |route| 
          route.any? { |r| r.include?(match) }
        }
      end

      puts Terminal::Table.new(
        # arain, these are already implemented in terminal-table, but gem is not released
        #:border_x => "",
        #:border_y => "",
        #:border_i => "",
        :rows => rows
      )
    end

    def help
      puts <<-HELP

Hi there! This is a pure web console
------------------------------------
  - you can run ruby as usual
  - you can run rake tasks just as you would in terminal "rake ..."
  - try up and down arrows to navigate past commands
  - variables work as wel (set a = 1, read a -> 1)

      HELP
    end
  end

  $rails_web_console_context ||= Context.new

  class ConsoleController < ::ActionController::Base
    skip_before_action :verify_authenticity_token
    layout false

    def index
      $rails_web_console_context = Context.new
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
          result = $rails_web_console_context.run command
        end
        $stdout.rewind
        stdout = 'error during stdout rewing'
        stdout = escape $stdout.read
      rescue Exception => e
        result = e
        stdout = escape(e.message) + "\n", e.backtrace[0..10].join("\n")
      end
      $stdout = stdout_orig
      render(json: {
        stdout: stdout,
        value: escape(result.inspect),
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
