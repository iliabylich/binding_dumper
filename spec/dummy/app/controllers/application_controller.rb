class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Exception, with: :log_binding

  def log_binding(e)
    StoredBinding.create(data: e._binding.dump)
    render json: {}
  end
end
