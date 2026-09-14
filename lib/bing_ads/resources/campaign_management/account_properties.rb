# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Account-level properties by name (GetAccountProperties, SetAccountProperties):
      # the account's tracking template, final URL suffix, MSCLKID auto-tagging,
      # parallel tracking, view-through conversion settings, and the other
      # +AccountPropertyName+ values.
      #
      # Both operations are REST POSTs — Set is +/AccountProperties/Set+, not a
      # PUT like the entity updates.
      class AccountProperties < Base
        service :campaign_management

        # Gets account-level properties by name (GetAccountProperties).
        #
        # +names+:: Array of +AccountPropertyName+ values to read, e.g.
        #           <tt>%w[TrackingUrlTemplate FinalUrlSuffix]</tt>.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +account_properties+ (an array of +{Name, Value}+
        # objects, one per requested name) and +partial_errors+.
        def find(names:, **options)
          post("/AccountProperties/Query", { account_property_names: names, **options }.compact)
        end

        # Sets account-level properties by name (SetAccountProperties).
        #
        # +properties+:: Array of <tt>{ name:, value: }</tt> pairs. Every +Value+ is a
        #                string (booleans as <tt>"true"</tt> / <tt>"false"</tt>); an
        #                empty string deletes a string-valued property such as
        #                +TrackingUrlTemplate+ or +FinalUrlSuffix+. Microsoft applies
        #                the list all-or-nothing.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an empty object on success.
        def update(properties:, **options)
          post("/AccountProperties/Set", { account_properties: properties, **options }.compact)
        end
      end
    end
  end
end
