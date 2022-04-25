module Errors
    extend ActiveSupport::Concern

    included do
      rescue_from(StandardError) { |e| handle_exception(e) }
    end

    private

    def handle_exception(e)
      case e
      when ActiveRecord::RecordNotFound
        error_response('record not found')
      when ActionController::ParameterMissing, KeyError
        error_response('parameter missing')
      else
        raise
      end
    end

    def error_response(error_messages, as_json = false)
      errors = case error_messages
      when ActiveRecord::Base
        ErrorSerializer.from_model(error_messages)
      else
        ErrorSerializer.from_messages(error_messages)
      end

      if as_json
        render json: errors, status: :unprocessable_entity
      else
        flash[:errors] = errors
        redirect_back(fallback_location: '/')
      end
    end
  end
