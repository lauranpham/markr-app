json.array! @results do |result|
  json.extract! result, :id, :mean, :min, :max, :p25, :p50, :p75, :count
end