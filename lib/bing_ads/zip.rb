# frozen_string_literal: true

require "zip"

module BingAds
  # ZIP support for Reporting/Bulk result files and Bulk uploads,
  # backed by rubyzip. (::Zip is rubyzip; this module is BingAds::Zip.)
  module Zip
    module_function

    # Extracts all file entries into to_dir (flattening paths); returns
    # the extracted file paths in archive order.
    def extract(zip_path, to_dir:)
      paths = []
      ::Zip::File.open(zip_path) do |archive|
        archive.each do |entry|
          next unless entry.file?

          path = File.join(to_dir, File.basename(entry.name))
          File.binwrite(path, entry.get_input_stream.read)
          paths << path
        end
      end
      paths
    rescue ::Zip::Error => e
      raise Error, "not a valid ZIP file: #{zip_path} (#{e.message})"
    end

    # Writes a ZIP archive containing a single entry.
    def create(zip_path, entry_name, data)
      ::Zip::OutputStream.open(zip_path) do |out|
        out.put_next_entry(entry_name)
        out.write(data)
      end
      zip_path
    end
  end
end
