# frozen_string_literal: true

require "test_helper"
require "tmpdir"

class TestZip < Minitest::Test
  def test_round_trip
    Dir.mktmpdir do |dir|
      zip_path = File.join(dir, "a.zip")
      content = "TimePeriod,Clicks\n2026-07-01,5\n" * 100
      BingAds::Zip.create(zip_path, "report.csv", content)

      extracted = BingAds::Zip.extract(zip_path, to_dir: dir)
      assert_equal [File.join(dir, "report.csv")], extracted
      assert_equal content, File.read(extracted.first)
    end
  end

  def test_extract_stored_entry
    Dir.mktmpdir do |dir|
      data = "hello"
      name = "s.txt"
      crc = Zlib.crc32(data)
      local = [0x04034b50, 20, 0, 0, 0, 0, crc, data.bytesize, data.bytesize,
               name.bytesize, 0].pack("Vv5V3v2")
      central = [0x02014b50, 20, 20, 0, 0, 0, 0, crc, data.bytesize, data.bytesize,
                 name.bytesize, 0, 0, 0, 0, 0, 0].pack("Vv6V3v5V2")
      cd_offset = local.bytesize + name.bytesize + data.bytesize
      eocd = [0x06054b50, 0, 0, 1, 1, central.bytesize + name.bytesize, cd_offset,
              0].pack("Vv4V2v")
      zip_path = File.join(dir, "stored.zip")
      File.binwrite(zip_path, local + name + data + central + name + eocd)

      extracted = BingAds::Zip.extract(zip_path, to_dir: dir)
      assert_equal "hello", File.read(extracted.first)
    end
  end

  def test_extract_rejects_non_zip
    Dir.mktmpdir do |dir|
      path = File.join(dir, "x.zip")
      File.binwrite(path, "not a zip at all")
      assert_raises(BingAds::Error) { BingAds::Zip.extract(path, to_dir: dir) }
    end
  end
end
