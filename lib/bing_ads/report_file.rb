# frozen_string_literal: true

require "csv"

module BingAds
  # Lightweight reader for downloaded report CSV/TSV files: skips the
  # Microsoft report metadata prologue and copyright footer and yields
  # data rows keyed by the column header row.
  module ReportFile
    module_function

    def each_row(path, col_sep: nil)
      return enum_for(:each_row, path, col_sep: col_sep) unless block_given?

      col_sep ||= File.extname(path).casecmp(".tsv").zero? ? "\t" : ","
      header = nil
      CSV.foreach(path, encoding: "bom|utf-8", col_sep: col_sep) do |row|
        cells = row.compact
        next if cells.empty?

        if header.nil?
          # Metadata prologue lines ("Report Name: ...") are single-cell.
          next if cells.length < 2

          header = row
          next
        end
        # Footer/copyright lines are single-cell too.
        next if cells.length < 2

        yield CSV::Row.new(header, row)
      end
    end

    def rows(path, col_sep: nil)
      each_row(path, col_sep: col_sep).to_a
    end
  end
end
