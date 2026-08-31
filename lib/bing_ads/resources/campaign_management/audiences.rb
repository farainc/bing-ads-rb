# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Audience CRUD and customer-list helpers
      # (AddAudiences, GetAudiencesByIds, UpdateAudiences, DeleteAudiences,
      # ApplyCustomerListItems, ApplyCustomerListUserData).
      class Audiences < Base
        service :campaign_management

        # Adds one or more audiences to the account (AddAudiences).
        #
        # +audiences+:: Array of Audience objects to add (maximum 100 per call).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +audience_ids+ and +partial_errors+.
        def create(audiences:, **options)
          post("/Audiences", { audiences: audiences, **options }.compact)
        end

        # Retrieves audiences by their identifiers (GetAudiencesByIds).
        #
        # +audience_ids+:: Optional. Array of audience identifiers (maximum 100). If nil,
        #                  all audiences in scope are returned.
        # +type+::         Optional. Space-delimited audience type filter, e.g.
        #                  <tt>"RemarketingList CustomerList"</tt>.
        # +return_additional_fields+:: Optional. Additional Audience properties to include.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +audiences+ and +partial_errors+.
        def find(audience_ids: nil, type: nil, return_additional_fields: nil, **options)
          post("/Audiences/QueryByIds",
               { audience_ids: audience_ids, type: Utils.flags(type),
                 return_additional_fields: Utils.flags(return_additional_fields), **options }.compact)
        end

        # Updates one or more existing audiences (UpdateAudiences).
        #
        # +audiences+:: Array of Audience objects to update (maximum 100 per call);
        #               each must include its +id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(audiences:, **options)
          put("/Audiences", { audiences: audiences, **options }.compact)
        end

        # Deletes audiences by identifier (DeleteAudiences).
        #
        # +audience_ids+:: Array of audience identifiers to delete (maximum 100 per call).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(audience_ids:, **options)
          request(:delete, "/Audiences", { audience_ids: audience_ids, **options }.compact)
        end

        # Applies items to a customer list audience (ApplyCustomerListItems).
        #
        # +customer_list_items+:: The customer list items to apply.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def apply_customer_list_items(customer_list_items: nil, **options)
          post("/CustomerListItems/Apply",
               { customer_list_items: customer_list_items, **options }.compact)
        end

        # Applies user data to a customer list audience (ApplyCustomerListUserData).
        #
        # +customer_list_user_data+:: A CustomerListUserData object describing the data to apply.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def apply_customer_list_user_data(customer_list_user_data: nil, **options)
          post("/CustomerListUserData/Apply",
               { customer_list_user_data: customer_list_user_data, **options }.compact)
        end
      end
    end
  end
end
