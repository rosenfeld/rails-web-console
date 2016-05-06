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

    SCRIPT_LIMIT = defined?(::WEB_CONSOLE_SCRIPT_LIMIT) ? ::WEB_CONSOLE_SCRIPT_LIMIT : 1000
    WARNING_LIMIT_MSG = "WARNING: stored script in session was limited to the first " +
      "#{SCRIPT_LIMIT} chars to avoid issues with cookie overflow\n"
    def run
      # we limit up to 1k to avoid ActionDispatch::Cookies::CookieOverflow (4k) which we 
      # can't rescue since it happens in a middleware
      script = params[:script]
      # we allow users to ignore the limit if they are using another session storage mechanism
      script = script[0...SCRIPT_LIMIT] unless defined?(::WEB_CONSOLE_IGNORE_SCRIPT_LIMIT)
      session[:script] = script
      stdout_orig = $stdout
      $stdout = StringIO.new
      begin
        puts WARNING_LIMIT_MSG if params[:script].size > SCRIPT_LIMIT &&
          !defined?(::WEB_CONSOLE_IGNORE_SCRIPT_LIMIT)
        result_eval = eval params[:script], binding
        $stdout.rewind
        result = %Q{<div class="stdout">#{escape $stdout.read}</div>
          <div class="return">#{escape result_eval.inspect}</div>}
      rescue Exception => e
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
