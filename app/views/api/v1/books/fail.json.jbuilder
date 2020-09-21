
json.code("412")
json.status("Precondition Failed")
json.data do
  json.message @message
end