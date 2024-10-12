class ApiErrorResponse
  attr_reader :error, :error_description

  def initialize(error, error_description = [])
    validate_params(error, error_description)

    @error = error.freeze
    @error_description = error_description.freeze
  end

  def self.not_found(precision = nil)
    text = I18n.t("errors.messages.not_found")
    text = "#{precision} #{text.downcase}" if precision.present?

    new(text)
  end

  private

  def validate_params(error, error_description)
    validate_error(error)
    validate_error_description(error_description)
  end

  def validate_error(error)
    raise ArgumentError, "`error` must be a String, got #{error.class}" unless error.is_a?(String)
  end

  def validate_error_description(error_description)
    return if error_description.is_a?(Array) && error_description.all? { |desc| desc.is_a?(String) }

    raise ArgumentError, "`error_description` must be an array of strings, got #{error_description.inspect}"
  end
end
