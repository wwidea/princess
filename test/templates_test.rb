#!/usr/bin/env ruby
# encoding: UTF-8

require 'test_helper'

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
    File.open(File.expand_path("../test_created_pdfs/#{name}.pdf", __FILE__), 'w+', :external_encoding => "ASCII-8BIT") do |file|
      file << @response.body
    end
  end
end
