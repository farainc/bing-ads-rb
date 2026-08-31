# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Conversion goal CRUD (AddConversionGoals, GetConversionGoalsByIds,
      # GetConversionGoalsByTagIds, UpdateConversionGoals).
      class ConversionGoals < Base
        service :campaign_management

        # Adds conversion goals to the customer's account (AddConversionGoals).
        #
        # +conversion_goals+:: Array of ConversionGoal objects to add (maximum 100 per call).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +conversion_goal_ids+ and +partial_errors+.
        def create(conversion_goals:, **options)
          post("/ConversionGoals", { conversion_goals: conversion_goals, **options }.compact)
        end

        # Gets conversion goals by their identifiers (GetConversionGoalsByIds).
        #
        # +conversion_goal_types+::    Flags enum of goal types to return,
        #                              e.g. <tt>"Url,Duration,Event"</tt> (an Array,
        #                              e.g. <tt>%w[Url Duration Event]</tt>, or a
        #                              legacy space-separated string are also
        #                              accepted and normalized).
        # +conversion_goal_ids+::      Optional. Array of conversion goal identifiers;
        #                              nil or empty returns all goals of the specified types.
        # +return_additional_fields+:: Optional. Additional ConversionGoal properties to
        #                              include in each returned object.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +conversion_goals+ and +partial_errors+.
        def find(conversion_goal_types:, conversion_goal_ids: nil, return_additional_fields: nil, **options)
          post("/ConversionGoals/QueryByIds",
               { conversion_goal_ids: conversion_goal_ids,
                 conversion_goal_types: Utils.flags(conversion_goal_types),
                 return_additional_fields: Utils.flags(return_additional_fields), **options }.compact)
        end

        # Gets conversion goals by UET tag identifiers (GetConversionGoalsByTagIds).
        #
        # +tag_ids+::                  Array of UET tag identifiers (maximum 100 per call).
        # +conversion_goal_types+::    Flags enum of goal types to return,
        #                              e.g. <tt>"Url,Duration,Event"</tt> (an Array or a
        #                              legacy space-separated string are also accepted
        #                              and normalized).
        # +return_additional_fields+:: Optional. Additional ConversionGoal properties to
        #                              include in each returned object.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +conversion_goals+ and +partial_errors+.
        def find_by_tag_ids(tag_ids:, conversion_goal_types:, return_additional_fields: nil, **options)
          post("/ConversionGoals/QueryByTagIds",
               { tag_ids: tag_ids,
                 conversion_goal_types: Utils.flags(conversion_goal_types),
                 return_additional_fields: Utils.flags(return_additional_fields), **options }.compact)
        end

        # Updates conversion goals (UpdateConversionGoals).
        #
        # +conversion_goals+:: Array of ConversionGoal objects to update (maximum 100 per call);
        #                      each must include its +id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(conversion_goals:, **options)
          put("/ConversionGoals", { conversion_goals: conversion_goals, **options }.compact)
        end
      end
    end
  end
end
