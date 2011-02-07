require 'prince'
require 'princess_provides_default_pdf'
require 'timeout'
module Princess
  # Makes and sends a pdf to the browser
  # 
  # === Arguments
  # Accepts any arguments that make_pdf accepts, plus...
  # * :filename - The name of the generated pdf file to send to the
  #   browser.  The '.pdf' suffix is optional.
  def send_pdf(opts = {})
    opts.reverse_merge!(:template => "#{controller_name}/#{action_name}",
      :stylesheet => princess_default_stylesheet,
      :layout => princess_default_layout,
      :filename => princess_default_filename)
    fn = opts.delete(:filename)
    send_data(
      make_pdf(opts),
      :filename => append_suffix(fn, :pdf),
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
  def make_pdf(opts = {}) #template_path, pdf_name, landscape=false)
    prince = Prince.new()
    
    # Sets style sheets on PDF renderer.
    if opts[:stylesheet] || opts[:stylesheets]
      prince.add_style_sheets(
        *(opts.delete(:stylesheets) || [opts.delete(:stylesheet)]).to_a.map do |sheet|
           "#{RAILS_ROOT}/public/stylesheets/#{append_suffix(sheet,:css)}"
        end
      )
    end
    
    #Extract collection for built in templates
    @pdf_collection = opts.delete(:collection) if opts[:collection]
    @pdf_partial = opts.delete(:partial) if opts[:partial]
    unless RAILS_ENV == 'test'
      @command_line_args = "--baseurl=#{request.protocol}#{request.host}#{RAILS_ENV == 'production' ? nil : ':'+(request.port+1).to_s}/"   #http://localhost:3001/"
    end
    
    # Set RAILS_ASSET_ID to blank string or rails appends some time after
    # to prevent file caching, fucking up local - disk requests.
    ENV["RAILS_ASSET_ID"] = ''
    
    # Override Rails attempt to look for .pdf.erb templates to render and
    # force it to look for the .html versions.
    @template.template_format = :html
    html_string = render_to_string(opts)
    # Return the generated PDF file from our html string.
    Timeout::timeout(21) do
      prince.pdf_from_string(html_string, :command_line_args => @command_line_args) 
    end
  end

  #appends the filename with the given suffix if necessary.
  # Examples:
  # * append_suffix(:tps_report,:pdf) => 'tps_report.pdf'
  # * append_suffix('my_styles.css',:css) => 'my_styles.css'  
  def append_suffix(filename,suffix)
    return filename.match(/\.#{suffix}$/) ? filename.to_s : "#{filename}.#{suffix}" 
  end
  
  def princess_default_layout
    pick_layout({})
  end
  
  def princess_default_stylesheet
    if File.exists?(RAILS_ROOT+"/public/stylesheets/#{params[:controller]}_default_pdf.css")
      "#{params[:controller]}_default_pdf"
    elsif File.exists?(RAILS_ROOT+"/public/stylesheets/application_default_pdf.css")
      'application_default_pdf'
    else
      nil
    end
  end
  
  def princess_default_filename
    "#{params[:controller]}_#{params[:action]}.pdf"
  end
end
