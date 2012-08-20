require "rubygems"
require "bundler/setup"

Bundler.require(:default)

ignore /\/_.*/, /Gemfile/, /\/config/, /\/css\/lib\/bootstrap\//

layout 'layout.html.haml'

helpers do
  def content_for(key, &block)
    @content ||= {}
    @content[key] = capture_haml(&block) if block_given?
    @content && @content[key]
  end
end

class Tilt::HamlTemplate
  def prepare
    options = @options.merge(:filename => eval_file, :line => line)
    # Custom options
    options = options.merge :ugly => true
    @engine = ::Haml::Engine.new(data, options)
  end
end