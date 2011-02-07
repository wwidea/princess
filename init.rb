# Include hook code here
require 'princess'
Mime::Type.register "application/pdf", :pdf
ActionController::Base.send(:include, Princess)
ActionController::Base.send(:include, PrincessProvidesDefaultPdf)