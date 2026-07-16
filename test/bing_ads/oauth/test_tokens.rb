# frozen_string_literal: true

require "test_helper"

class TestOAuthTokens < Minitest::Test
  def test_holds_fields
    tokens = BingAds::OAuth::Tokens.new(
      access_token: "at", refresh_token: "rt", expires_in: 3600, raw: { "scope" => "s" }
    )
    assert_equal "at", tokens.access_token
    assert_equal "rt", tokens.refresh_token
    assert_equal 3600, tokens.expires_in
    assert_equal({ "scope" => "s" }, tokens.raw)
  end

  def test_not_expired_when_fresh
    tokens = BingAds::OAuth::Tokens.new(access_token: "at", expires_in: 3600, issued_at: Time.now)
    refute tokens.expired?
  end

  def test_expired_within_leeway
    tokens = BingAds::OAuth::Tokens.new(access_token: "at", expires_in: 3600,
                                        issued_at: Time.now - 3400)
    assert tokens.expired? # 200s left < 300s default leeway
  end

  def test_expired_past_expiry
    tokens = BingAds::OAuth::Tokens.new(access_token: "at", expires_in: 3600,
                                        issued_at: Time.now - 4000)
    assert tokens.expired?
  end

  def test_unknown_expiry_is_not_expired
    tokens = BingAds::OAuth::Tokens.new(access_token: "at")
    refute tokens.expired?
    assert_nil tokens.expires_at
  end

  def test_inspect_redacts_token_values
    tokens = BingAds::OAuth::Tokens.new(access_token: "SECRET_AT", refresh_token: "SECRET_RT")
    refute_includes tokens.inspect, "SECRET_AT"
    refute_includes tokens.inspect, "SECRET_RT"
  end

  def test_data_value_semantics
    tokens = BingAds::OAuth::Tokens.new(access_token: "at", refresh_token: "rt", expires_in: 3600)
    assert_predicate tokens, :frozen?
    rotated = tokens.with(access_token: "at2")
    assert_equal "at2", rotated.access_token
    assert_equal "rt", rotated.refresh_token
    assert_equal tokens, tokens.with
  end
end
