
json.code("201")
json.status("Created")
json.data do
  json.id @service_result.data.id
  json.mail @service_result.data.mail
  json.token @service_result.data.token
end