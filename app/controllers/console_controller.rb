require 'stringio'
class ConsoleController < ApplicationController
  def index
  end

  def run
    session[:script] = params[:script]
    stdout_orig = $stdout
    $stdout = StringIO.new
    begin
      result_eval = eval params[:script], binding
      $stdout.rewind
      result = %Q{<div class="stdout">#{$stdout.read}</div><div class="return">#{result_eval.inspect}</div>}
    rescue Exception => e
      result = e.to_s
    end
    $stdout = stdout_orig
    render text: result.gsub("\n", "<br />\n")
  end
end
