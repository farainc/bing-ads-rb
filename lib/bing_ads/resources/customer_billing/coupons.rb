# frozen_string_literal: true

module BingAds
  module Resources
    module CustomerBilling
      # Coupon management (RedeemCoupon, SearchCoupons, GetCouponInfo, DispatchCoupons, and internal APIs).
      class Coupons < Base
        service :customer_billing

        # Redeems a coupon to the specified account (RedeemCoupon).
        #
        # +account_id+:: Identifier of the account to which the coupon is redeemed.
        # +coupon_code+:: Code of the coupon to redeem.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +redemption_date+.
        def redeem(account_id:, coupon_code:, **options)
          post("/Coupon/Redeem", { account_id: account_id, coupon_code: coupon_code, **options }.compact)
        end

        # Searches for coupons matching specified criteria owned by a customer (SearchCoupons).
        #
        # +predicates+:: Array of Predicate objects (up to 4); one must have field CustomerId.
        # +page_info+:: Paging object specifying index and page size.
        # +ordering+:: Optional. Array of OrderBy objects determining sort order (only first element is used).
        # +return_additional_fields+:: Optional. Pass <tt>"CouponClaimInfo"</tt> to include claim info in results.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +coupons+ array.
        def search(predicates:, page_info:, ordering: nil, return_additional_fields: nil, **options)
          post("/Coupons/Search",
               { predicates: predicates, ordering: ordering, page_info: page_info,
                 return_additional_fields: Utils.flags(return_additional_fields), **options }.compact)
        end

        # Gets coupon information associated with a customer (GetCouponInfo).
        #
        # +customer_id+:: The customer identifier.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +coupon_info_data+ array.
        def info(customer_id:, **options)
          post("/CouponInfo/Query", { customer_id: customer_id, **options }.compact)
        end

        # Dispatches available coupons of a coupon class to the specified email addresses (DispatchCoupons).
        #
        # +send_to_emails+:: Array of email addresses to dispatch coupons to (maximum 1000).
        # +customer_id+:: Identifier of the customer that owns the coupon class.
        # +coupon_class_name+:: Name of the coupon class whose available coupons are dispatched.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +partial_errors+ array.
        def dispatch_coupons(send_to_emails:, customer_id:, coupon_class_name:, **options)
          post("/Coupons/Dispatch",
               { send_to_emails: send_to_emails, customer_id: customer_id,
                 coupon_class_name: coupon_class_name, **options }.compact)
        end

        # Distributes coupons (internal API — request body fields are not publicly documented).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns the API response.
        def distribute(**options)
          post("/Coupons/Distribute", options)
        end

        # Checks feature adoption coupon eligibility (internal API — request body fields are not publicly documented).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns the API response.
        def check_feature_adoption_eligibility(**options)
          post("/FeatureAdoptionCouponEligibility/Check", options)
        end

        # Claims feature adoption coupons (internal API — request body fields are not publicly documented).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns the API response.
        def claim_feature_adoption(**options)
          post("/FeatureAdoptionCoupons/Claim", options)
        end
      end
    end
  end
end
