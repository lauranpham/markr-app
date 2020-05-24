class ResultsController < ApplicationController
    skip_before_action :verify_authenticity_token, :only => :create
    def index
        @results = Result.all
    end

    def aggregate
        @result = Result.find(params[:id])
    end

    def create
        results = Nokogiri::XML(request.raw_post).xpath("//mcq-test-result")
        ## Create result/test instances
        test_ids = []
        results.xpath("test-id").each do |test_id| 
            if Result.find_by(id: test_id.text.to_i).nil?
                Result.create(id: test_id.text.to_i)
            end
            test_ids.push(test_id.text.to_i)
        end 

        ## Create students and scores
        results.each do |result|
            student_id = result.xpath("student-number").text.to_i
            test_id = result.xpath("test-id").text.to_i
            obtained =  result.xpath("summary-marks").attribute("obtained").text.to_i
            available = result.xpath("summary-marks").attribute("available").text.to_i
            first_name = result.xpath("first-name").text
            last_name = result.xpath("last-name").text
            next result if student_duplicate(student_id, test_id, first_name, last_name)
            next result if score_duplicate(student_id, test_id, obtained, first_name, last_name)
            Student.create(id: student_id, first_name: first_name, last_name: last_name)
            Score.create(obtained: obtained, available: available, result_id: test_id, student_id: student_id)
        end

        ## Update aggregate scores of imported results
        if test_ids.uniq.length > 1 
            test_ids.uniq!.each do |test_id|
                aggregate_scores(test_id) 
            end 
        else 
            aggregate_scores(test_ids[0]) 
        end
    end

    def student_duplicate(student_id, test_id, first_name, last_name)
        if Student.find_by(id: student_id).present? && Student.find_by(id: student_id)["first_name"] != first_name
            # Print error message about duplicate student id
            print "The test #{test_id} for #{first_name} #{last_name} is under a duplicate student number #{student_id}. This result will be ignored."
            return true
        else  
            return false
        end
    end
    
    def score_duplicate(student_id, test_id, obtained, first_name, last_name)
        current_score = Score.find_by(student_id: student_id, result_id: test_id)
        if current_score.present?
            if current_score.obtained < obtained
                # Print error message about current score being higher and overriding
                print "This is a duplicate score for #{first_name} #{last_name} (#{student_id}). The new score is #{obtained}"
                current_score.update_attribute(:obtained, obtained)
            end
            # Print error message about current score being lower
            print "This is a duplicate score for #{first_name} #{last_name} (#{student_id}). The score remains #{current_score.obtained}"
            return true
        else
            return false
        end 
    end

    def aggregate_scores(test_id)
        obtained_scores = 0.to_f
        class_available_marks = 0.to_f
        scores = []
        Score.where(result_id: test_id).each do |score| 
            obtained_scores += score.obtained
            class_available_marks += score.available
            scores << score.obtained.to_f
        end
        count = scores.length
        ordered_scores = scores.sort
        available_marks = class_available_marks/count 
        mean = ((obtained_scores/count/available_marks) * 100).round(1)
        min = ((ordered_scores.first/available_marks) * 100).round(1)
        max = ((ordered_scores.last/available_marks) * 100).round(1)
        # data = {p25: , p50: , p75: }
        data = stats(ordered_scores, available_marks)
        result = Result.find(test_id)
        result.update(mean: mean, min: min, max: max, p25: data[:p25], p50: data[:p50], p75: data[:p75], count: count, available_marks: available_marks)
        result.save
    end 

    def stats(ordered_scores, available_marks)
        # add 1 to account for indexes starting at 0 
        median_index = (ordered_scores.length + 1) / 2.0 - 1
        if median_index % 2 != 0
            median = (ordered_scores[median_index.ceil] + ordered_scores[median_index.floor])/2
        else
            median = ordered_scores[median_index]
        end
        p25 = ordered_scores[((ordered_scores.length) * 25.0/100).ceil - 1]
        p50 = ordered_scores[((ordered_scores.length) * 75.0/100).ceil - 1]
        data = {
            p25: p25,
            p50: median,
            p75: p50,
        }
        return Hash[data.map{ |k,pvalue| [k, (pvalue.to_f/20 * 100).round(1)] }]
    end 

end
