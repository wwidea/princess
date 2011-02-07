require 'test_helper'

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
      format.pdf {
        send_pdf(map.merge(:collection => %w(one two three four)))
      }
    end
  end
end


class ReportsControllerTest < ActionController::TestCase
  test "should create address labels report" do
    post :create, :report => {:format => 'address_labels_avery_5160'}, :format => 'pdf'
    assert_response :success
    assert @response.body.match(/^%PDF/), "Report Format - address_labels_avery_5160"
    write_response_to_file('address_labels')
  end
  
  test "should create nametags report" do
    post :create, :report => {:format => 'nametags_avery_5390'}, :format => 'pdf'
    assert_response :success
    assert @response.body.match(/^%PDF/), "nametags_avery_5390"
    write_response_to_file('nametags')
  end
  
  
  #######
  private
  #######
  
  def write_response_to_file(name)
    File.open(File.expand_path(RAILS_ROOT + "/test_created_pdfs/#{name}.pdf"), 'w+') do |file|
      file << @response.body
    end
  end
end
