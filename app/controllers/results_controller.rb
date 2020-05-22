class ResultsController < ApplicationController
    def index
        @results = Result.all
    end

    def aggregate
        @result = Result.find(params[:id])
    end

    def import
        doc = Nokogiri::XML(request.raw_post)
        results = doc.xpath("//mcq-test-result")
        create(results) 
    end 

    def create(results)
    end
end
