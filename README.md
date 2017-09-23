# AttachmentPath

Some Helper methods to generate url and get filename from attachment path

[![Build Status](https://travis-ci.org/xiejiangzhi/attachment_helper.svg?branch=master)](https://travis-ci.org/xiejiangzhi/attachment_helper)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'attachment_path'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attachment_path

## Usage

### Setup

```
AttachmentHelper.attachment_host = 'http://myhost.com'
```

### Define attachments

```
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
```

### helper methods

```
topic = Topic.new
```

Helper methods for path

```
topic.logo_url # => 'http://myhost.com/uploads/a.png?size=100x100'
topic.logo_url(size: 200, t: 123) # => 'http://myhost.com/uploads/a.png?size=200&t=123'
topic.logo_filename # => 'a.png'
```

Helper methods for url

```
topic.pdf_url # => 'http://hello.com/assets/a.pdf'
topic.pdf_url(foo: :bar) # => 'http://hello.com/assets/a.pdf?foo=bar'
topic.pdf_filename # => 'a.pdf'
```

Helper methods for a list

```
topic.image_urls # => ['http://hello/a.png', 'http://other.com/b.png']
topic.image_urls(a: :foo) # => ['http://hello/a.png?a=foo', 'http://other.com/b.png?a=foo']
topic.image_filenames # => ['a.png', 'b.png']
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xiejiangzhi/attachment_helper.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
