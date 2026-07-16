# frozen_string_literal: true

module BingAds
  module Resources
    module CustomerManagement
      # Notification management (GetNotifications, DismissNotifications).
      class Notifications < Base
        service :customer_management

        # Gets a list of notification objects (GetNotifications).
        #
        # +locale+:: Optional. Locale of the notification message; defaults to <tt>"en"</tt>.
        # +user_id+:: Optional. UserId filter.
        # +type_ids+:: Optional. Array of notification type IDs to filter by.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +notifications+ array.
        def list(locale: nil, user_id: nil, type_ids: nil, **options)
          post("/Notifications/Query", { locale: locale, user_id: user_id, type_ids: type_ids, **options }.compact)
        end

        # Dismisses the specified notifications (DismissNotifications).
        #
        # +notification_ids+:: Optional. Array of notification IDs to dismiss.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an empty response body.
        def dismiss(notification_ids: nil, **options)
          post("/Notifications/Dismiss",
               { notification_ids: notification_ids, **options }.compact)
        end
      end
    end
  end
end
