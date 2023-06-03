module ExceptionHandler
  extend ActiveSupport::Concern
  
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class BadRequest < StandardError; end
  class AccessDenied < StandardError; end
    
  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_response
    rescue_from ExceptionHandler::MissingToken, with: :unprocessable_response
    rescue_from ExceptionHandler::InvalidToken, with: :unprocessable_response
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_response
    rescue_from ExceptionHandler::BadRequest, with: :bad_request_response
    rescue_from ExceptionHandler::AccessDenied, with: :access_denied_response
  end
  
  private
  
  #403
  def access_denied_response(e)
    json_response({ message: e.message }, :forbidden)
  end
  
  #400
  def bad_request_response(e)
    json_response({ message: e.message }, :bad_request)
  end
  
  #404
  def not_found_response(e)
    json_response({ message: e.message }, :not_found)
  end
  
  # 422
  def unprocessable_response(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end
  
  # 401
  def unauthorized_response(e)
    json_response({ message: e.message }, :unauthorized)
  end
end