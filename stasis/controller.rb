require "rubygems"
require "bundler/setup"

Bundler.require(:default)

ignore /\/_.*/, /Gemfile/, /\/config/
layout 'layout.html.haml'

helpers do
  def content_for(key, &block)
    @content ||= {}
    @content[key] = capture_haml(&block) if block_given?
    @content && @content[key]
  end
end