# frozen_string_literal: true

module BingAds
  module Resources
    module CustomerBilling
      # Billing document retrieval (GetBillingDocuments, GetBillingDocumentsInfo, GetAccountMonthlySpend).
      class BillingDocuments < Base
        service :customer_billing

        # Gets the specified billing documents (GetBillingDocuments).
        #
        # +billing_documents_info+:: Array of BillingDocumentInfo objects identifying the documents to
        #                            retrieve; each must contain CustomerId and DocumentId (up to 25 items).
        # +type+:: Format for the generated document, e.g. <tt>"Pdf"</tt> or <tt>"Xml"</tt>.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +billing_documents+ array.
        def list(billing_documents_info:, type:, **options)
          post("/BillingDocuments/Query",
               { billing_documents_info: billing_documents_info, type: type, **options }.compact)
        end

        # Gets billing document identification info for the specified accounts and date range (GetBillingDocumentsInfo).
        #
        # +account_ids+:: Array of account identifiers whose billing document info to retrieve.
        # +start_date+:: Start of the date range (UTC). Cannot be later than +end_date+.
        # +end_date+:: Optional. End of the date range (UTC). Pass +nil+ to use today's date.
        # +return_invoice_number+:: Optional. Whether to include the invoice number in the response.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +billing_documents_info+ array.
        def info(account_ids:, start_date:, end_date: nil, return_invoice_number: nil, **options)
          post("/BillingDocumentsInfo/Query",
               { account_ids: account_ids, start_date: start_date, end_date: end_date,
                 return_invoice_number: return_invoice_number, **options }.compact)
        end

        # Gets the amount spent by an account in a specified month (GetAccountMonthlySpend).
        #
        # +account_id+:: Identifier of the account (must use invoice payment method).
        # +month_year+:: Month and year for the spend query, e.g. <tt>"2026-05"</tt>.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with an +amount+ field (double).
        def monthly_spend(account_id:, month_year:, **options)
          post("/AccountMonthlySpend/Query", { account_id: account_id, month_year: month_year, **options }.compact)
        end
      end
    end
  end
end
