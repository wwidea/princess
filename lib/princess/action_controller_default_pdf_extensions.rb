# = Princess ActionController Extensions
# Only loaded if user declares 'princess_provides_default_pdf' in controller.
module ActionController #:nodoc:
  class Base #:nodoc:
    def render_for_file_with_princess_default_pdf(template_path, *args)
      if params[:format] == 'pdf' and !does_template_exist?(template_path)
        template_path = default_template_name
      end
      @template.template_format = :html
      render_for_file_without_princess_default_pdf(template_path, *args)
    end
    # alias_method_chain :render_for_file, :princess_default_pdf
    
    def default_template_name_with_princess_default_pdf(*args)
      dtn = default_template_name_without_princess_default_pdf(*args)
      if params[:format] == 'pdf' and !does_template_exist?(dtn)
        if does_template_exist?(dtn+'.html.erb')
          dtn += '.html.erb'
        elsif does_template_exist?(dtn+'.rhtml')
          dtn += '.rhtml'
        end
      end
      return dtn
    end
    # alias_method_chain :default_template_name, :princess_default_pdf
    
    #######
    private
    #######
    
    def does_template_exist?(path)
      self.view_paths.find_template(path, response.template.template_format)
    rescue ActionView::MissingTemplate
      false
    end
  end
  
  module MimeResponds #:nodoc:
    class Responder #:nodoc:
      def respond_with_princess_default_pdf
        unless @responses[Mime.const_get('PDF')]
          self.pdf do
            @controller.send(:send_pdf)
          end
        end
        respond_without_princess_default_pdf
      end
      # alias_method_chain :respond, :princess_default_pdf
    end
  end
end