# frozen_string_literal: true

require 'pathname'
require 'tmpdir'

class DownloadTS
  attr_reader :url

  def initialize(url:)
    @url = url
  end

  def call
    `cat #{download_part_files.join(' ')} > #{basename}.mp4`
  end

  private

  def download_part_files
    i = 0

    while system("wget -O #{part_path(i)} #{url}_#{i}.ts")
      i += 1
    end

    (0...i).map { |i| part_path(i) }
  end

  def tmp_dir
    @tmp_dir ||= Pathname.new(Dir.mktmpdir('download-ts-'))
  end

  def part_path(i)
    "#{tmp_dir.join(basename)}_#{i}.ts"
  end

  def basename
    url.split('/')[-2]
  end
end
