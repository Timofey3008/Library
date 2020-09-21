
json.code("200")
json.status("OK")
json.data do
  json.merge! @book.attributes
end