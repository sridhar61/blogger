require 'rufus-scheduler'
require 'open-uri'

require 'csv'


scheduler = Rufus::Scheduler::singleton


scheduler.every '5s' do
  begin
    if open("http://www.google.com/")
      articles = Array.new
        CSV.foreach('articles.csv') do |record|
          puts record[0]
          unless Post.all.map(&:title).include?(record[0])
            Post.create(title: record[0], body: record[1])
          end
        end            
    end 
  rescue
    false 
  end  
end


