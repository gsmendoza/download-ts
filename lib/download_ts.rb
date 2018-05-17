# frozen_string_literal: true

require 'pathname'
require 'tmpdir'

class DownloadTS
  attr_reader :url

  def initialize(url:)
    @url = url
  end

  def call
    i = 0

    while system("wget -O #{part_path(i)} #{url}_#{i}.ts")
      `cat #{part_path(i)} >> #{basename}.mp4`

      i += 1
    end
  end

  private

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
