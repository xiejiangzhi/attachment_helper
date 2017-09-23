require 'attachment_helper'

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

puts topic.logo_url
puts topic.logo_url(size: 200, t: 123)
puts topic.logo_filename

puts topic.pdf_url
puts topic.pdf_url(foo: :bar)
puts topic.pdf_filename

puts topic.image_urls.inspect
puts topic.image_urls(a: :foo).inspect
puts topic.image_filenames.inspect

