
json.code("200")
json.status("OK")
json.data do
  json.array! @books do |book|
    json.merge! book.attributes
  end
end