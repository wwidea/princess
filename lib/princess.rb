#!/usr/bin/env ruby
# encoding: UTF-8

require 'princess/prince'
require 'princess/generate_pdf'

ActionController::Base.send(:include, Princess::GeneratePdf)

Mime::Type.register "application/pdf", :pdf

# add pdf render option
# example:
#  respnd_to do |format
#    format.pdf { render :pdf => options }
#  end
ActionController.add_renderer :pdf do |template, options|
  
  Rails.logger.debug '****************************** PDF RENDERER START ************************************'
  Rails.logger.debug template.inspect
  Rails.logger.debug '****************************** PDF RENDERER 1 ************************************'
  Rails.logger.debug options.inspect
  Rails.logger.debug '****************************** PDF RENDERER END ************************************'
  
  self.formats = [:html, :pdf]
  send_pdf(template)
end
