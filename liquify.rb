#!/usr/bin/env ruby

def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end


require 'liquid'
require 'lib/albino'
require_all 'lib/tags'


class FakeConfig
  attr_reader :pygments, :config
  def initialize
    @pygments = true
    @config = {
      'dot' => {
        'out_dir' => '_img',
        'out_url' => 'http://github.com/rabbitmq/rabbitmq-tutorials/raw/master/python/_img',
        'opts' => '-Gbgcolor=transparent -Gtruecolor=true',
      },
    }
  end
end

info = {
  :registers => {:site => FakeConfig.new},
}

payload = {
  'dotstyle' => {
    'producer' => 'style="filled", fillcolor="#00ffff"',
    'queue' => 'style="filled", fillcolor="red", shape="record"',
    'consumer'=> 'style="filled", fillcolor="#33ccff"',
  },
}

content = IO.read(ARGV[0])
template = Liquid::Template.parse(content)
puts template.render(payload, info)
