# frozen_string_literal: true

require "test_helper"

class TestObject < Minitest::Test
  def wrap(data)
    BingAds::Object.wrap(data)
  end

  def test_snake_case_method_access
    obj = wrap("CampaignIds" => %w[1 2], "PartialErrors" => [nil])
    assert_equal %w[1 2], obj.campaign_ids
    assert_equal [nil], obj.partial_errors
  end

  def test_nested_hashes_wrap_recursively
    obj = wrap("Campaign" => { "BiddingScheme" => { "Type" => "ManualCpcBiddingScheme" } })
    assert_equal "ManualCpcBiddingScheme", obj.campaign.bidding_scheme.type
  end

  def test_arrays_of_hashes_wrap
    obj = wrap("Campaigns" => [{ "Name" => "A" }, { "Name" => "B" }])
    assert_equal %w[A B], obj.campaigns.map(&:name)
  end

  def test_acronym_keys_accessible
    obj = wrap("LastSyncTimeInUTC" => "2026-07-16T00:00:00Z")
    assert_equal "2026-07-16T00:00:00Z", obj.last_sync_time_in_utc
  end

  def test_raw_access_and_to_h
    data = { "CampaignIds" => %w[1] }
    obj = wrap(data)
    assert_equal %w[1], obj["CampaignIds"]
    assert_equal data, obj.to_h
  end

  def test_respond_to_missing
    obj = wrap("Name" => "x")
    assert_respond_to obj, :name
    refute_respond_to obj, :nonexistent
  end

  def test_unknown_key_raises_no_method_error
    obj = wrap("Name" => "x")
    assert_raises(NoMethodError) { obj.nonexistent }
  end

  def test_wrap_passes_scalars_and_nil_through
    assert_equal 5, wrap(5)
    assert_nil wrap(nil)
    assert_equal "s", wrap("s")
  end

  def test_equality
    assert_equal wrap("A" => 1), wrap("A" => 1)
  end
end
