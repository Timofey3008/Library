require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/users' do

    get('Show list of users') do
      tags "Users"
      security [ bearerAuth: [] ]
      parameter(
          name: 'limit',
          in: :query,
          type: :integer,
          description: 'Count of users on the page'
      )
      parameter(
          name: 'page',
          in: :query,
          type: :integer,
          description: 'Page number'
      )

      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post('Registration of user') do
      tags "Users"
      consumes "application/json"
      parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
              mail: { type: :string},
              password: { type: :string },
          },
          required: ["mail", "password"],
      }

      response(201, 'created') do

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('Show user') do
      tags "Users"
      security [ bearerAuth: [] ]
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/api/v1/login' do
    post('Login') do
      tags "Users"
      consumes "application/json"
      parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
              mail: { type: :string},
              password: { type: :string },
          },
          required: ["mail", "password"],
      }

      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end
end
