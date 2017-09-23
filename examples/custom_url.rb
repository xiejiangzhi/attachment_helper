require 'attachment_helper'

AttachmentHelper.attachment_host = 'http://myhost.com'

module ExtAttachmentURL
  def get_url_by_path(path, opts = {})
    if path =~ /https?:\/\/private\.com/
      super(path, opts.merge(token: 'signed_token'))
    else
      super
    end
  end
end

AttachmentHelper.singleton_class.prepend(ExtAttachmentURL)

class Topic
  include AttachmentHelper

  has_attachments [:logo_path, {size: '100x100'}], :pdf_path, :image_paths

  def logo_path
    'http://private.com/a.png'
  end

  def image_paths
    ['a.png', 'http://private.com/b.png']
  end
end

topic = Topic.new

puts topic.logo_url
puts topic.logo_url(size: 200, t: 123)

puts topic.image_urls
puts topic.image_urls(size: 200, t: 123)


