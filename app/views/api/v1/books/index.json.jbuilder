
json.array! @books do |book|
  json.merge! book.attributes
end