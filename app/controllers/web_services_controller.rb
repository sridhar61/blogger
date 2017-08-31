require 'cassandra'

class WebServicesController < ApplicationController
  

  def request_form
  
  end
  
  def send_request
    @ori = params[:ori]
    results = search_database(@ori)
    if results.present?
      extract_stop_data
      render :send_request, status: :sent_rquest
    end
  end
  
  def cassandra_connect 
    cluster = Cassandra.cluster(hosts: "ec2-13-58-26-103.us-east-2.compute.amazonaws.com")
    session  = cluster.connect('ab953')  
  end
  
  def search_database(ori)
    @ori = ori
    session = cassandra_connect
    info = session.execute("SELECT * FROM stops_by_ori_reason where ori='#{@ori}'").execution_info
  end
  
  def extract_stop_data
    
    #session = cassandra_connect
    #info = session.execute("SELECT stop_duration, date_time FROM stops_by_ori_reason where ori='#{@ori}'") 
  end
  
  
  
  
end
