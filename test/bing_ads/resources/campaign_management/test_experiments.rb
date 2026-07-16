# frozen_string_literal: true

require "test_helper"

class TestExperimentsResource < Minitest::Test
  include ResourceTestHelper

  def test_create
    stub = stub_op(:post, "#{CM}/Experiments", { "Experiments" => [{ "Name" => "E" }] })
    sdk_client.campaign_management.experiments.create(experiments: [{ name: "E" }])
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/Experiments/QueryByIds", { "ExperimentIds" => [6] })
    sdk_client.campaign_management.experiments.find(experiment_ids: [6])
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/Experiments", { "Experiments" => [{ "Id" => 6 }] })
    sdk_client.campaign_management.experiments.update(experiments: [{ "Id" => 6 }])
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/Experiments", { "ExperimentIds" => [6] })
    sdk_client.campaign_management.experiments.delete(experiment_ids: [6])
    assert_requested stub
  end
end
