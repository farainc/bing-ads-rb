# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Account-level and miscellaneous Campaign Management operations.
      class Utilities < Base
        service :campaign_management

        # Returns the Microsoft Merchant Center stores for the customer (GetBMCStoresByCustomerId).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an array of +BMCStore+ objects.
        def bmc_stores(**options)
          post("/BMCStores/QueryByCustomerId", { **options }.compact)
        end

        # Gets a temporary URL to download the profile data file (GetProfileDataFileUrl).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +file_url+, +file_url_expiry_time_utc+, and +last_modified_time_utc+.
        def profile_data_file_url(**options)
          post("/ProfileDataFileUrl/Query", { **options }.compact)
        end

        # Gets a temporary URL to download the geographical locations file (GetGeoLocationsFileUrl).
        #
        # +version+:: Version of the location file to download; currently only <tt>"2.0"</tt>
        #             is supported.
        # +language_locale+:: Language and locale of the display names, e.g. <tt>"en"</tt>,
        #                     <tt>"fr"</tt>, <tt>"de"</tt>, <tt>"zh-Hant"</tt>.
        # +compression_type+:: Optional. Compression format for the downloaded file; currently only
        #                      <tt>"GZip"</tt> is supported. If omitted, the file is uncompressed.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +file_url+, +file_url_expiry_time_utc+, and +last_modified_time_utc+.
        def geo_locations_file_url(version:, language_locale:, compression_type: nil, **options)
          post("/GeoLocationsFileUrl/Query",
               { version: version, language_locale: language_locale, compression_type: compression_type,
                 **options }.compact)
        end

        # Gets the migration status for the specified accounts (GetAccountMigrationStatuses).
        #
        # +account_ids+:: Array of account identifiers to query migration status for.
        # +migration_type+:: Filters the returned statuses by migration type.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +migration_statuses+ array of +AccountMigrationStatusesInfo+ objects.
        def account_migration_statuses(account_ids:, migration_type:, **options)
          post("/AccountMigrationStatuses/Query",
               { account_ids: account_ids, migration_type: migration_type, **options }.compact)
        end

        # Gets the annotation opt-out setting for the current account (GetAnnotationOptOut).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with the +opt_out+ boolean setting.
        def annotation_opt_out(**options)
          post("/AnnotationOptOut/Query", { **options }.compact)
        end

        # Sets the annotation opt-out setting for the current account (SetAnnotationOptOut).
        #
        # +opt_out+:: Optional. Set to +true+ to opt out of annotations, +false+ to opt in.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an empty response on success.
        def update_annotation_opt_out(opt_out: nil, **options)
          put("/AnnotationOptOut", { opt_out: opt_out, **options }.compact)
        end

        # Gets the list of supported sales country codes for Microsoft Shopping Campaigns (GetBSCCountries).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +country_codes+ string array.
        def bsc_countries(**options)
          post("/BSCCountries/Query", { **options }.compact)
        end

        # Gets available Clipchamp video templates (GetClipchampTemplates).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +clipchamp_templates+ array.
        def clipchamp_templates(**options)
          post("/ClipchampTemplates/Query", { **options }.compact)
        end

        # Gets the supported Clipchamp audio tracks (GetSupportedClipchampAudio).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +supported_clipchamp_audio+ array.
        def supported_clipchamp_audio(**options)
          post("/SupportedClipchampAudio/Query", { **options }.compact)
        end

        # Gets the supported fonts for ad creative (GetSupportedFonts).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +supported_fonts+ array.
        def supported_fonts(**options)
          post("/SupportedFonts/Query", { **options }.compact)
        end

        # Gets diagnostics information for the account (GetDiagnostics).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +diagnostics+ data.
        def diagnostics(**options)
          post("/Diagnostics/Query", { **options }.compact)
        end

        # Performs a health check on the Campaign Management service (GetHealthCheck).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with the service +health+ status.
        def health_check(**options)
          post("/HealthCheck/Query", { **options }.compact)
        end
      end
    end
  end
end
