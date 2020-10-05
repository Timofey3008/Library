require 'swagger_helper'

RSpec.describe 'api/v1/books', type: :request do

  path '/api/v1/books' do
    get('List of books') do
      tags "Books"
      security [ bearerAuth: [] ]
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
      response '401', 'authentication failed' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('bogus:bogus')}" }
        run_test!
      end
    end

    post('Registration of the book') do
      tags "Books"
      security [ bearerAuth: [] ]
      consumes "application/json"
      parameter name: :book, in: :body, schema: {
          type: :object,
          properties: {
              name: { type: :string },
          },
          required: ["name"],
      }

      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
      response '401', 'authentication failed' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('bogus:bogus')}" }
        run_test!
      end
    end
  end

  path '/api/v1/books/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string

    get('Show book') do
      tags "Books"
      security [ bearerAuth: [] ]
      response(200, 'successful') do
        let(:id) { '12' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
      response '401', 'authentication failed' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('bogus:bogus')}" }
        run_test!
      end
    end
   end

  path '/api/v1/books/reserve/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string

    put('Reserve book') do
      tags "Books"
      security [ bearerAuth: [] ]
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
      response '401', 'authentication failed' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('bogus:bogus')}" }
        run_test!
      end
    end
  end

  path '/api/v1/books/return/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    put('Return book') do
      tags "Books"
      security [ bearerAuth: [] ]
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
      response '401', 'authentication failed' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('bogus:bogus')}" }
        run_test!
      end
    end
  end

  path '/api/v1/book/user_read' do

    get('Show book which user read') do
      tags "Books"
      security [ bearerAuth: [] ]
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
      response '401', 'authentication failed' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('bogus:bogus')}" }
        run_test!
      end
    end
  end

  path '/api/v1/book/own_books' do

    get('Show own books') do
      tags "Books"
      security [ bearerAuth: [] ]
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
      response '401', 'authentication failed' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('bogus:bogus')}" }
        run_test!
      end
    end
  end

  path '/api/v1/book/available_books' do

    get('Show available books') do
      tags "Books"
      security [ bearerAuth: [] ]
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
      response '401', 'authentication failed' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('bogus:bogus')}" }
        run_test!
      end
    end
  end

  path '/api/v1/book/return_to_owner/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    put('Return book to owner') do
      tags "Books"
      security [ bearerAuth: [] ]
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
      response '401', 'authentication failed' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('bogus:bogus')}" }
        run_test!
      end
    end
  end

  path '/api/v1/book/expired' do

    get('Show expired books') do
      tags "Books"
      security [ bearerAuth: [] ]
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
      response '401', 'authentication failed' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('bogus:bogus')}" }
        run_test!
      end
    end
  end
end
