# frozen_string_literal: true

module BingAds
  # Shared polling loop used by the async Reporting and Bulk operation handles.
  module Polling
    module_function

    # Polls +block+ until it returns a truthy value (returned to caller) or
    # +timeout+ seconds elapse (raises +Timeout::Error+).
    #
    # +interval+:: Seconds between polls (default 5).
    # +timeout+:: Maximum total seconds to wait before raising +Timeout::Error+ (default 3600).
    #
    # Returns the first truthy value returned by +block+.
    def wait_for(interval: 5, timeout: 3600)
      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      loop do
        result = yield
        return result if result

        elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started
        raise Timeout::Error, "polling timed out after #{timeout} seconds" if elapsed >= timeout

        sleep(interval)
      end
    end
  end
end
