class ResultsController < ApplicationController
    def index
        @results = Result.all
    end

    def aggregate
        @result = Result.find(params[:id])
    end

    def import
        file = Nokogiri::XML(request.raw_post)
        create(file) 
    end 

    def create(file)
        results = file.xpath("//mcq-test-result")
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
    end 

end
