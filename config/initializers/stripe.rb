Rails.configuration.stripe = {
  :publishable_key => ENV['pk_test_es4CkNWbkdZhRSUR7kuvWAtY'],
  :secret_key      => ENV['sk_test_OmkGlhIaJtHKds4z19BMNK76']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]