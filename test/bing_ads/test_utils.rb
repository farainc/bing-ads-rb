# frozen_string_literal: true

require "test_helper"

class TestUtils < Minitest::Test
  def test_camelize_basic
    assert_equal "DailyBudget", BingAds::Utils.camelize(:daily_budget)
    assert_equal "Type", BingAds::Utils.camelize(:type)
    assert_equal "Name", BingAds::Utils.camelize("name")
  end

  def test_camelize_acronyms
    assert_equal "LastSyncTimeInUTC", BingAds::Utils.camelize(:last_sync_time_in_utc)
    assert_equal "HTML5s", BingAds::Utils.camelize(:html5s)
    assert_equal "HTML5Ids", BingAds::Utils.camelize(:html5_ids)
  end

  def test_register_acronyms
    original = BingAds.acronyms
    BingAds.register_acronyms("sku" => "SKU", vat: "VAT")
    assert_equal "SKUIds", BingAds::Utils.camelize(:sku_ids)
    assert_equal "VATNumber", BingAds::Utils.camelize(:vat_number)
    assert_equal "LastSyncTimeInUTC", BingAds::Utils.camelize(:last_sync_time_in_utc) # defaults kept
    assert_predicate BingAds.acronyms, :frozen?
  ensure
    BingAds.instance_variable_set(:@acronyms, original)
  end

  def test_camelize_keys_recurses_and_preserves_string_keys
    input = {
      account_id: "456",
      campaigns: [
        {
          name: "Test",
          bidding_scheme: { type: "ManualCpcBiddingScheme" },
          "ForwardCompatibilityMap" => [{ "key" => "K", "value" => "V" }]
        }
      ]
    }
    expected = {
      "AccountId" => "456",
      "Campaigns" => [
        {
          "Name" => "Test",
          "BiddingScheme" => { "Type" => "ManualCpcBiddingScheme" },
          "ForwardCompatibilityMap" => [{ "key" => "K", "value" => "V" }]
        }
      ]
    }
    assert_equal expected, BingAds::Utils.camelize_keys(input)
  end

  def test_camelize_keys_passes_scalars_through
    assert_equal 5, BingAds::Utils.camelize_keys(5)
    assert_nil BingAds::Utils.camelize_keys(nil)
  end

  def test_flags_normalizes_arrays_and_spaces_to_commas
    assert_nil BingAds::Utils.flags(nil)
    assert_equal "Url,Duration,Event", BingAds::Utils.flags(%w[Url Duration Event])
    assert_equal "Url,Duration,Event", BingAds::Utils.flags("Url Duration Event")
    assert_equal "Url,Duration,Event", BingAds::Utils.flags("Url,Duration,Event")
    assert_equal "Url,Event", BingAds::Utils.flags("Url,  Event")
    assert_equal "Search", BingAds::Utils.flags("Search")
    assert_equal "Search", BingAds::Utils.flags(:Search)
    assert_equal "", BingAds::Utils.flags([])
  end

  def test_underscore
    assert_equal "campaign_ids", BingAds::Utils.underscore("CampaignIds")
    assert_equal "last_sync_time_in_utc", BingAds::Utils.underscore("LastSyncTimeInUTC")
    assert_equal "type", BingAds::Utils.underscore("Type")
  end
end
