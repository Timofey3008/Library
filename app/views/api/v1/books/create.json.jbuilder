
json.code("201")
json.status("OK")
json.data do
  json.merge! @book.attributes
end