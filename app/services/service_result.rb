class ServiceResult
  attr_reader :status, :exception, :message, :data, :errors, :cached

  def initialize(status:, exception: nil, message: nil, data: nil, errors: [], log_data: true, log: true, cached: false)
    @status = status
    @exception = exception
    @message = message
    @message ||= exception_message(exception) if exception.present?
    @data = data
    @errors = errors
    @log_data = log_data
    @cached = cached


    if log
      Rails.logger.try(@status ? :info : :error, @message) if @message
      Rails.logger.error(exception_message(exception)) if exception.present? && message.present?
      Rails.logger.info self.to_s
    end
  end

  def success?
    status == true
  end

  def failure?
    !success?
  end

  def has_data?
    data.present?
  end

  def has_errors?
    errors.present? && errors.length > 0
  end

  def to_s
    "- Service result: #{success? ? 'Success!' : 'Failure!'} - #{message} - #{@log_data ? data : 'data log is disabled'}#{@cached ? ' - cached' : ''}"
  end

  private

  def exception_message(exception)
    "Error occurred - #{exception.message}\n#{exception.backtrace.join("\n")}"
  end
end
