# frozen_string_literal: true

namespace :cache do
  desc 'Checks if the cache is disabled and enables it'

  def green(message)
    "\e[32m#{message}\e[0m"
  end

  task fetch: :environment do
    if Rails.application.config.action_controller.perform_caching
      next puts green('Development mode is already being cached.')
    end

    exec('rake dev:cache')
  end
end
