# Include hook code here
Mime::Type.register "application/pdf", :pdf
ActionController::Base.send(:include, Princess)
ActionController::Base.send(:include, PrincessProvidesDefaultPdf)