# frozen_string_literal: true

Stripe.api_key = Settings.stripe.api_key
Stripe.max_network_retries = 2
Stripe.open_timeout = 120
Stripe.read_timeout = 80
Stripe.write_timeout = 30
Stripe.logger = Application.logger
