# Attachment Helper
#
# Specify some attachment reader:
#   # avatar_path: a string
#   # pdf_paths: a array of string
#   has_attachments :avatar_path, :pdf_paths
#   # or
#   has_attachments [:avatar_path, {size: '100x100'}], :pdf_paths
#
# Generated Methods:
#   avatar_url
#   avatar_filename
#   pdf_urls
#   pdf_filenames

module AttachmentHelper
  module ClassMethods
    # field => options
    def has_attachments(*fields)
      fields.each do |field, opts|
        default_opts = AttachmentHelper.symbolize_keys(opts || {})
        case field
        when /_paths$/
          define_attachments_methods(field.to_s, default_opts)
        else
          define_attachment_methods(field.to_s, default_opts)
        end
      end
    end

    def define_attachment_methods(field, default_opts = {})
      prefix = field.gsub(/_path$/, '')
      m_url, m_filename = ["#{prefix}_url", "#{prefix}_filename"]

      # {name}_url
      define_method(m_url) do |options = {}|
        val = self.public_send(field)

        AttachmentHelper.get_url_by_path(
          val, default_opts.merge(AttachmentHelper.symbolize_keys(options))
        )
      end

      # attachment/{uuid}/filename.pdf return filename.pdf
      define_method(m_filename) do
        val = self.public_send(field)
        AttachmentHelper.get_filename_by_path(val)
      end
    end

    def define_attachments_methods(field, default_opts)
      prefix = field.gsub(/_paths$/, '')
      m_urls, m_filenames = ["#{prefix}_urls", "#{prefix}_filenames"]

      define_method(m_urls) do |options = {}|
        val = self.public_send(field)
        return nil if val.nil?
        Array(val).map do |v|
          AttachmentHelper.get_url_by_path(
            v, default_opts.merge(AttachmentHelper.symbolize_keys(options))
          )
        end
      end

      define_method(m_filenames) do
        val = self.public_send(field)
        return nil if val.nil?
        Array(val).map { |v| AttachmentHelper.get_filename_by_path(v) }
      end
    end
  end
end
