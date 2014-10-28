module Whitehouse
  class Error < StandardError
    ConfigurationError = Class.new(::ArgumentError)

    ImageHashMismatch = Class.new(self)
    ImageNotFound = Class.new(self)
    ErrorCopyingFiles = Class.new(self)
    InvalidCallbackURI = Class.new(self)
    CallbackVerification = Class.new(self)

    NotAuthorized = Class.new(self)
    AuthorizationExpired = Class.new(NotAuthorized)
    InvalidCredentials = Class.new(NotAuthorized)
    IncorrectGrantType = Class.new(NotAuthorized)

    InvalidOrder = Class.new(self)
    IncorrectOrderImport = Class.new(InvalidOrder)
    InvalidBusinessRules = Class.new(InvalidOrder)
    InvalidConfirmationId = Class.new(InvalidOrder)
    EntryAlreadySubmitted = Class.new(InvalidOrder)
    UnsupportedVersion = Class.new(InvalidOrder)
    InvalidEmail = Class.new(InvalidOrder)

    CODES = {
      "400.01" => ImageHashMismatch,
      "400.02" => ImageNotFound,
      "400.03" => ErrorCopyingFiles,
      "400.04" => InvalidCallbackURI,
      "400.05" => CallbackVerification,
      "403"    => NotAuthorized,
      "403.01" => AuthorizationExpired,
      "403.02" => InvalidCredentials,
      "403.03" => InvalidCredentials,
      "403.04" => InvalidCredentials,
      "403.05" => IncorrectGrantType,
      "412.01" => IncorrectOrderImport,
      "412.02" => InvalidBusinessRules,
      "412.03" => InvalidConfirmationId,
      "412.04" => EntryAlreadySubmitted,
      "412.05" => UnsupportedVersion,
      "412.06" => InvalidEmail
    }.freeze
  end
end
