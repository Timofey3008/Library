
json.code("400")
json.status("Bad Request")
json.data do
  json.message @message
end