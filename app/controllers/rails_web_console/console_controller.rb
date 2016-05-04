require 'stringio'

module RailsWebConsole
  class ConsoleController < ::ActionController::Base
    if _process_action_callbacks.any?{|a| a.filter == :verify_authenticity_token}
      # ActionController::Base no longer protects from forgery in Rails 5
      skip_before_filter :verify_authenticity_token
    end
    layout false

    def index
    end

    def run
      session[:script] = params[:script]
      stdout_orig = $stdout
      $stdout = StringIO.new
      begin
        result_eval = eval params[:script], binding
        $stdout.rewind
        result = %Q{<div class="stdout">#{escape $stdout.read}</div>
          <div class="return">#{escape result_eval.inspect}</div>}
      rescue => e
        result = e.to_s
      end
      $stdout = stdout_orig
      render text: result.gsub("\n", "<br>\n")
    end

    private

    def escape(content)
      view_context.escape_once content
    end
  end
end
