# frozen_string_literal: true

Application.logger = Ougai::Logger.new(
  $stdout,
  level: Settings.log_level || Logger::INFO
)

# Auxiliary tags for logging
Application.logger.with_fields = { environment: Application.environment }
