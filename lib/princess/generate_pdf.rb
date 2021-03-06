#!/usr/bin/env ruby
# encoding: UTF-8

require 'timeout'

module Princess
  module GeneratePdf
    # Makes and sends a pdf to the browser
    # 
    # === Arguments
    # Accepts any arguments that make_pdf accepts, plus...
    # * :filename - The name of the generated pdf file to send to the
    #   browser.  The '.pdf' suffix is optional.
    def send_pdf(options = {})
      options.reverse_merge!(
        :stylesheet => princess_default_stylesheet,
        :filename => princess_default_filename)

      filename = options.delete(:filename)

      send_data(
        make_pdf(options),
        :filename => append_suffix(filename, :pdf),
        :type => 'application/pdf'
      )
    end

    #######
    private
    #######

    # Makes a pdf, returns it as data...
    #
    # === Arguments
    # Accepts any arguments that render_to_string accepts, plus...
    # * :stylesheet(s) - a single (or array of) string(s) or symbol(s) naming
    #   stylesheets in public/stylesheets. passing the '.css' suffix is optional.
    # * :collection - a collection of objects to use with built in templates
    # * :partial - a partial that defines the layout for one object in a built in template
    #
    # === Built-in Templates
    # Princess comes with some built in templates for generating labels. Simply pass
    # the name of the one of the available builtin templates with the :template
    # argument.  The following builtin templates are currently available...
    # * :avery_5390 - nametags
    # * :avery_8160 - small address labels (coming soon)
    #
    # === Examples
    # * make_pdf(:stylesheet => :reports, ...)
    # * make_pdf(:stylesheets => [:transcript,:landscape,:fancy_tables], ...)
    # * make_pdf(:template => 'avery_5390', :collection => @people, :partial => 'person_nametag', ...)
    def make_pdf(options = {}) #template_path, pdf_name, landscape=false)
      prince = Princess::Prince.new()

      # Sets style sheets on PDF renderer.
      if options[:stylesheet] || options[:stylesheets]
        prince.add_style_sheets(
          *(options.delete(:stylesheets) || [options.delete(:stylesheet)]).to_a.map do |sheet|
             Rails.root.join('public', 'stylesheets', append_suffix(sheet, :css))
          end
        )
      end

      #Extract collection for built in templates
      @pdf_collection = options.delete(:collection) if options[:collection]
      @pdf_partial = options.delete(:partial) if options[:partial]
      unless Rails.env == 'test'
        @command_line_args = "--baseurl=#{request.protocol}#{request.host}#{Rails.env == 'production' ? nil : ':'+(request.port+1).to_s}/"   #http://localhost:3001/"
      end

      # Set RAILS_ASSET_ID to blank string or rails appends some time after
      # to prevent file caching, fucking up local - disk requests.
      ENV["RAILS_ASSET_ID"] = ''

      # render html view
      html_string = render_to_string(options)
      # Return the generated PDF file from our html string.
      Timeout::timeout(21) do
        prince.pdf_from_string(html_string, :command_line_args => @command_line_args) 
      end
    end

    #appends the filename with the given suffix if necessary.
    # Examples:
    # * append_suffix(:tps_report, :pdf) => 'tps_report.pdf'
    # * append_suffix('my_styles.css', :css) => 'my_styles.css'  
    def append_suffix(filename, suffix)
      return filename.match(/\.#{suffix}$/) ? filename.to_s : "#{filename}.#{suffix}"
    end
    
    def princess_default_stylesheet
      if File.exists?(Rails.root.join('public', 'stylesheets', "#{params[:controller]}_default_pdf.css"))
        "#{params[:controller]}_default_pdf"
      elsif File.exists?(Rails.root.join('public', 'stylesheets', "application_default_pdf.css"))
        'application_default_pdf'
      else
        nil
      end
    end

    def princess_default_filename
      "#{params[:controller]}_#{params[:action]}.pdf"
    end 
  end
end
