class ResultsController < ApplicationController
    def index
        @results = Result.all
    end

    def aggregate
        @result = Result.find(params[:id])
    end 
end
