# frozen_string_literal: true

require "attachment_helper/class_methods"
require "attachment_helper/version"

require 'uri'

module AttachmentHelper
  class << self
    attr_accessor :attachment_host

    def included(cls)
      cls.extend(AttachmentHelper::ClassMethods)
    end

    def attachment_host
      @attachment_host ||= 'http://please-set-attachment-host.com'
    end


    def symbolize_keys(hash)
      hash.each_with_object({}) {|kv, r| r[(kv.first.to_sym rescue kv.first)] = kv.last }
    end

    def get_url_by_path(path, options = {})
      return if path.nil?
      query = options.empty? ? '' : "?#{URI.encode_www_form(options)}"
      if path =~ /^http/
        "#{path}#{query}"
      else
        "#{AttachmentHelper.attachment_host}/#{path}#{query}"
      end
    end

    def get_filename_by_path(path)
      return if path.nil?
      path.split('/').last
    end
  end
end
