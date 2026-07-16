# frozen_string_literal: true

require "test_helper"
require "tmpdir"

class TestReportFile < Minitest::Test
  CONTENT = <<~CSV
    "Report Name: My Report"
    "Report Time: 7/1/2026 - 7/15/2026"

    "TimePeriod","CampaignName","Clicks"
    "2026-07-01","Campaign A","5"
    "2026-07-02","Campaign B","7"
    "©2026 Microsoft Corporation. All rights reserved."
  CSV

  def with_report_file(content = CONTENT, ext = ".csv")
    Dir.mktmpdir do |dir|
      path = File.join(dir, "report#{ext}")
      File.write(path, content)
      yield path
    end
  end

  def test_yields_data_rows_with_headers
    with_report_file do |path|
      rows = BingAds::ReportFile.rows(path)
      assert_equal 2, rows.length
      assert_equal "Campaign A", rows.first["CampaignName"]
      assert_equal "7", rows.last["Clicks"]
    end
  end

  def test_skips_prologue_and_footer
    with_report_file do |path|
      values = BingAds::ReportFile.rows(path).map { |r| r["TimePeriod"] }
      assert_equal %w[2026-07-01 2026-07-02], values
    end
  end

  def test_tsv_separator_from_extension
    tsv = CONTENT.gsub('","', "\"\t\"")
    with_report_file(tsv, ".tsv") do |path|
      rows = BingAds::ReportFile.rows(path)
      assert_equal "Campaign A", rows.first["CampaignName"]
    end
  end

  def test_each_row_returns_enumerator_without_block
    with_report_file do |path|
      enum = BingAds::ReportFile.each_row(path)
      assert_kind_of Enumerator, enum
      assert_equal 2, enum.count
    end
  end
end
