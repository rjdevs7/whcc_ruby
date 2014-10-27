module Whitehouse
  class Error < StandardError
    ConfigurationError = Class.new(::ArgumentError)

    NotAuthorized = Class.new(self)
    AuthorizationExpired = Class.new(NotAuthorized)

    InvalidOrder = Class.new(self)
    IncorrectOrderImport = Class.new(InvalidOrder)
    InvalidBusinessRules = Class.new(InvalidOrder)
    InvalidConfirmationId = Class.new(InvalidOrder)
    EntryAlreadySubmitted = Class.new(InvalidOrder)

    CODES = {
      "403.01" => AuthorizationExpired,
      "412.01" => IncorrectOrderImport,
      "412.02" => InvalidBusinessRules,
      "412.03" => InvalidConfirmationId,
      "412.04" => EntryAlreadySubmitted,
    }.freeze
  end
end
