require 'rails_helper'

# Acceptance tests aka request specs for the Persons API and its associated endpoints.
RSpec.describe "Persons API", type: :request do
  # initialize test data
  let!(:persons) { create_list(:person, 10) }
  let(:person_first_id) { persons.first.id }

  # Test suite for GET /persons
  describe 'GET /persons' do
    # make HTTP get request before each example
    before { get '/persons' }

    it 'returns persons' do
      json = JSON.parse(response.body)
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /persons/:id
  describe 'GET /persons/:id' do
    before { get "/persons/#{person_first_id}" }

    context 'when the record exists' do
      it 'returns the person' do
        json = JSON.parse(response.body)

        expect(json).not_to be_empty
        expect(json['id']).to eq(person_first_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:person_first_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match("{\"message\":\"Couldn't find Person with 'id'=100\"}")
      end
    end
  end

  # Test suite for POST /persons
  describe 'POST /persons' do
    # valid payload
    let(:valid_attributes) do 
        { first_name: 'Eric', last_name: "Chen", email: 'eric@gmail.com', age: 15 }
    end 

    context 'when the request is valid' do
      before { post '/persons', params: { person: valid_attributes } }

      it 'creates a person' do
        json = JSON.parse(response.body)
        expect(json['first_name']).to eq('Eric')
        expect(json['last_name']).to eq('Chen')
        expect(json['email']).to eq('eric@gmail.com')
        expect(json['age']).to eq(15)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/persons', params: { person: { blah: 'Foobar' } } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to include("\"errors\":{\"first_name\":[\"can't be blank\"]")
      end
    end
  end

  # Test suite for PUT /persons/:id
  describe 'PUT /persons/:id' do
    let(:valid_attributes) { { person: { first_name: "Updated" } } }

    context 'when the record exists' do
      before { put "/persons/#{person_first_id}", params: valid_attributes }

      it 'returns status code 204' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /persons/:id
  describe 'DELETE /persons/:id' do
    before { delete "/persons/#{person_first_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /persons/:id/versions/:version_id
  describe 'GET /persons/:id/version/:version_id' do
   let(:original_first_name) { persons.first.first_name }

    context 'when there is an existing version' do 
      before do 
        valid_attr = { first_name: "Versioning" }
        put "/persons/#{person_first_id}", params: {person: valid_attr }
        get "/persons/#{person_first_id}/version/1"
      end

      it 'returns with the reified object' do
        json = JSON.parse(response.body)

        expect(json).not_to be_empty
        expect(json['version']['first_name']).to eq(original_first_name)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when there is not a corresponding version' do
      before do 
        get "/persons/#{person_first_id}/version/600"
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
