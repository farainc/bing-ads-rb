# frozen_string_literal: true

require "test_helper"

class TestPolling < Minitest::Test
  def test_returns_immediately_when_first_poll_succeeds
    result = BingAds::Polling.wait_for { :ok }
    assert_equal :ok, result
  end

  def test_times_out
    assert_raises(Timeout::Error) do
      BingAds::Polling.wait_for(interval: 1, timeout: 5) { nil }
    end
  end
end
