# frozen_string_literal: true

require "test_helper"

class TestUtilitiesResource < Minitest::Test
  include ResourceTestHelper

  QUERY_OPS = {
    bmc_stores: "BMCStores/QueryByCustomerId",
    profile_data_file_url: "ProfileDataFileUrl/Query",
    annotation_opt_out: "AnnotationOptOut/Query",
    bsc_countries: "BSCCountries/Query",
    clipchamp_templates: "ClipchampTemplates/Query",
    supported_clipchamp_audio: "SupportedClipchampAudio/Query",
    supported_fonts: "SupportedFonts/Query",
    diagnostics: "Diagnostics/Query",
    health_check: "HealthCheck/Query"
  }.freeze

  def test_all_query_operations
    QUERY_OPS.each do |method, path|
      stub = stub_op(:post, "#{CM}/#{path}")
      sdk_client.campaign_management.utilities.public_send(method)
      assert_requested stub
    end
  end

  def test_geo_locations_file_url_params
    stub = stub_op(:post, "#{CM}/GeoLocationsFileUrl/Query",
                   { "Version" => "2.0", "LanguageLocale" => "en" })
    sdk_client.campaign_management.utilities.geo_locations_file_url(version: "2.0", language_locale: "en")
    assert_requested stub
  end

  def test_account_migration_statuses
    stub = stub_op(:post, "#{CM}/AccountMigrationStatuses/Query",
                   { "AccountIds" => [123], "MigrationType" => "SiteLinksAdExtension" })
    sdk_client.campaign_management.utilities.account_migration_statuses(
      account_ids: [123], migration_type: "SiteLinksAdExtension"
    )
    assert_requested stub
  end

  def test_update_annotation_opt_out
    stub = stub_op(:put, "#{CM}/AnnotationOptOut", { "OptOut" => true })
    sdk_client.campaign_management.utilities.update_annotation_opt_out(opt_out: true)
    assert_requested stub
  end
end
