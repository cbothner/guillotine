class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?
  around_filter :print_latex_errors

  protect_from_forgery

  def print_latex_errors
    begin
      yield
    rescue ActionView::Template::Error => e
      raise unless e.message[/latex/]

      logger.error "Failed to create PDF..."

      log_file = e.message.scan(/\/.*\.log/).first
      if log_file && File.exists?(log_file)
        puts "--- Latex Log ---\n"
        puts File.read(log_file)
        puts "---    End    ---\n\n"
      end
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :email
  end
end
