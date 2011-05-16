class ReportsController < ApplicationController

  REPMAPS = {
    'address_labels_avery_5160' => {
      :template => '/princess/avery_5160',
      :partial => 'address_label',
      :filename => 'address_labels',
      :stylesheet => 'address_labels',
      :layout => false
    },
    'nametags_avery_5390' => {
      :template => '/princess/avery_5390',
      :partial => 'nametag',
      :filename => 'nametags',
      :stylesheet => 'nametags',
      :layout => false
    }
  }
  
  def create
    map = REPMAPS[params[:report][:format]]

    respond_to do |format|
      format.pdf { render :pdf => map.merge(:collection => %w(one two three four)) }
    end
  end
end
