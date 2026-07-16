# frozen_string_literal: true

require "tmpdir"
require "fileutils"

module BingAds
  module Resources
    # Shared logic for the async Reporting/Bulk operations: fetch a
    # result-file URL to an exact local path. With decompress the ZIP
    # is downloaded and extracted in a private temp directory, then the
    # (single) inner file is moved to `path` — the caller always gets
    # the artifact at exactly the path they asked for.
    module ResultFile
      module_function

      # Downloads the file at +url+ to exactly +path+, optionally decompressing the ZIP.
      #
      # +connection+:: A +BingAds::Connection+ instance used to stream the download.
      # +url+:: The pre-signed download URL returned by a status response.
      # +path+:: Local filesystem path where the result file will be written.
      # +decompress+:: When true, the ZIP is extracted and the inner file is moved to +path+.
      # +overwrite+:: When false, raises +Error+ if +path+ already exists.
      #
      # Returns +path+ on success.
      def fetch(connection, url, path:, decompress:, overwrite:)
        raise Error, "#{path} already exists" if File.exist?(path) && !overwrite
        return connection.download(url, to: path) unless decompress

        Dir.mktmpdir("bing_ads") do |tmp|
          zip_path = File.join(tmp, "result.zip")
          connection.download(url, to: zip_path)
          FileUtils.mv(Zip.extract(zip_path, to_dir: tmp).first, path)
        end
        path
      end
    end
  end
end
