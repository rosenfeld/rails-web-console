require 'stringio'

module RailsWebConsole
  class ConsoleController < ::ActionController::Base
    skip_before_action :verify_authenticity_token
    layout false

    def index
    end

    def run
      session[:script] = params[:script]

      stdout = ''
      stdout_orig = $stdout
      $stdout = StringIO.new
      begin
        result_eval = eval params[:script], binding
        $stdout.rewind
        stdout = 'error during stdout capture'
        stdout = escape $stdout.read
        result = result_eval
      rescue => e
        result = e.to_s
      end
      $stdout = stdout_orig
      render(json: {
        stdout: stdout,
        value: escape(result),
        type: result.class.name
      })
    end

    private

    def escape(content)
      view_context.escape_once content
    end
  end
end
