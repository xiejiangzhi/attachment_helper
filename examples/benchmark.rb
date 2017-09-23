require 'attachment_helper'
require 'benchmark'

AttachmentHelper.attachment_host = 'http://myhost.com'

class Topic
  include AttachmentHelper

  has_attachments [:logo_path, {size: '100x100'}], :pdf_path, :image_paths

  def logo_path
    'uploads/a.png'
  end

  def pdf_path
    'http://hello.com/assets/a.pdf'
  end

  def image_paths
    ['a.png', 'http://other.com/b.png']
  end
end

topic = Topic.new

total_times = 100000
puts "Times: #{total_times}"

Benchmark.bm do |x|
  x.report('Run logo_url') do
    total_times.times do
      topic.logo_url
    end
  end

  x.report('Run logo_url(opts)') do
    total_times.times do
      topic.logo_url(foo: :bar, long: 'this_is_some_long_text')
    end
  end

  x.report('Run logo_filename') do
    total_times.times do
      topic.logo_filename
    end
  end

  x.report('Run pdf_url') do
    total_times.times do
      topic.pdf_url
    end
  end

  x.report('Run pdf_url(opts)') do
    total_times.times do
      topic.pdf_url(foo: :bar, long: 'this_is_some_long_text')
    end
  end

  x.report('Run image_urls') do
    total_times.times do
      topic.image_urls
    end
  end

  x.report('Run image_urls(opts)') do
    total_times.times do
      topic.image_urls(foo: :bar, long: 'this_is_some_long_text')
    end
  end

  x.report('Run image_filenames') do
    total_times.times do
      topic.image_filenames
    end
  end
end
