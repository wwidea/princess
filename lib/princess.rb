#!/usr/bin/env ruby
# encoding: UTF-8

require 'princess/prince'
require 'princess/generate_pdf'

ActionController::Base.send(:include, Princess::GeneratePdf)

Mime::Type.register "application/pdf", :pdf

# add pdf render option
# example:
#  respnd_to do |format
#    format.pdf { render :pdf => true }
#    format.pdf { render :pdf => 'template_name' }
#    format.pdf { render :pdf => options_hash }
#  end
ActionController.add_renderer :pdf do |options, view_hash|
  
  self.formats = [:html, :pdf]
  
  # for true render the template for the current action
  if options == true
    options = {}
  # use string for template name
  elsif options.is_a?(String)
    options = { :template => options }
    # add view path prefix unless tempate is a fully qualifed path
    options.merge!(:prefix => view_hash[:prefix]) unless options[:template].index('/')
  end
  
  Rails.logger.debug "Sending PDF: #{options.inspect}"
    
  send_pdf(options)
end
