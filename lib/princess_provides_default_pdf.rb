module PrincessProvidesDefaultPdf#:nodoc:
  
  def self.included( base ) 
    base.extend( SingletonMethods )
  end
    
  module SingletonMethods
    # Hooks into ActionController internals to intercept outgoing html and 
    # render it into a pdf if {:format => 'pdf'} was requested and not fulfilled
    # by the controller action. 
    #
    # Declare at the top of any controllers you want to provide this feature
    # or in the Application Controller for site wide.
    def princess_provides_default_pdf(opts={})
      require 'princess/action_controller_default_pdf_extensions'
      send :prepend_after_filter, :send_default_pdf
      send :prepend_before_filter, :fix_ie_headers
      send :include, PrincessProvidesDefaultPdf::InstanceMethods
    end
  end
  
  module InstanceMethods #:nodoc:
    # Some versions of Microthoughts Inadequate Exploiter have their HTTP_ACCEPT
    # header set to tell the server they would prefer anything BUT html, which
    # really screws things up for the rest of the world.  So, lets try to make
    # up for their stupidity.  
    def fix_ie_headers
      if request.env['HTTP_ACCEPT'] and
          params[:format].nil? and
          request.env['HTTP_ACCEPT'].index('application/pdf') and
          (
            request.env['HTTP_ACCEPT'].index('text/html').nil? or
            request.env['HTTP_ACCEPT'].index('text/html') > request.env['HTTP_ACCEPT'].index('application/pdf')
          )         
        request.env['HTTP_ACCEPT'] = 'text/html,' + request.env['HTTP_ACCEPT'].to_s
      end
    end
    
    def send_default_pdf
      #if the requested format was pdf, and we havent' already rendered a pdf
      if params[:format] == 'pdf' and response.content_type != 'application/pdf'
        previously_rendered = response.body
        erase_render_results 
        respond_to do |format|
          format.pdf do
            send_pdf(
              :text => previously_rendered,
              :stylesheet => princess_default_stylesheet,
              :layout => princess_default_layout,
              :filename => princess_default_filename
            )
          end
        end
      end
    end
  end
end

