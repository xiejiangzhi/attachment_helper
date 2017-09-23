RSpec.describe AttachmentHelper::ClassMethods do
  let(:cls) do
    Class.new do
      include AttachmentHelper

      attr_accessor :avatar, :img, :logo_path, :gallery_paths

      has_attachments(
        [:avatar, { size: '100x100' }], :img, :logo_path, [:gallery_paths, { a: 1 }]
      )
    end
  end

  let(:user) { cls.new }
  let(:download_host) { 'http://please-set-attachment-host.com' }

  describe 'attachment url' do
    it 'should return nil if key is nil' do
      expect(user.avatar_url).to eql(nil)
      expect(user.img_url).to eql(nil)
      expect(user.logo_url).to eql(nil)
      expect(user.gallery_urls).to eql(nil)
    end

    it 'should add download_host prefix' do
      user.img = 'files/a.png'
      expect(user.img_url).to eql("#{download_host}/#{user.img}")

      user.logo_path = 'files/b.png'
      expect(user.logo_url).to eql("#{download_host}/#{user.logo_path}")
    end

    it 'should return array with download_host if key is an array' do
      user.gallery_paths = ['files/a.png', 'files/b.png']
      expect(user.gallery_urls).to eql(["#{download_host}/files/a.png?a=1",
                                        "#{download_host}/files/b.png?a=1"])
    end

    it 'should return origin data if key is a url' do
      user.avatar = 'http://xxx'
      expect(user.avatar_url).to eql(user.avatar + '?size=100x100')
      expect(user.img_url).to eql(nil)
    end

    fit 'should support options' do
      user.avatar = 'http://hello.com/a.png'
      user.img = 'b.png'
      user.gallery_paths = ['http://hello.com/a.png', 'files/b.png']

      expect(user.avatar_url(size: 1)).to eql("http://hello.com/a.png?size=1")
      expect(user.img_url(a: :b)).to eql("#{download_host}/b.png?a=b")
      expect(user.gallery_urls(v: 1)).to eql(
        [ "http://hello.com/a.png?a=1&v=1", "#{download_host}/files/b.png?a=1&v=1" ]
      )
    end
  end

  describe 'attachment filename' do
    it 'should return nil if key is nil' do
      expect(user.avatar_filename).to eql(nil)
      expect(user.img_filename).to eql(nil)
      expect(user.logo_filename).to eql(nil)
      expect(user.gallery_filenames).to eql(nil)
    end

    it 'should return filename' do
      user.img = 'files/a.png'
      expect(user.img_filename).to eql("a.png")

      user.img = 'files/uuid/b.png'
      expect(user.img_filename).to eql("b.png")

      user.img = 'http://f.com/files/uuid/c.png'
      expect(user.img_filename).to eql("c.png")

      user.logo_path = 'files/uuid/d.png'
      expect(user.logo_filename).to eql("d.png")
    end

    it 'should return filenames array' do
      user.gallery_paths = ['files/uuid/a.png', 'files/uuid/b.png']
      expect(user.gallery_filenames).to eql(['a.png', 'b.png'])
    end
  end
end
