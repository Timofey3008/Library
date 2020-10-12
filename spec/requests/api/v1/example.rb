# frozen_string_literal: true

require 'swagger_helper'

RSpec.shared_examples 'Not found' do
  response '404', 'Not found' do
    let(:id) { create(:campaign, organization: user.organization).id + 1 }

    examples(load_examples('application/json', 'v1/examples/errors'))

    run_test! { expect(parsed_response).to eq('status' => 404, 'error' => 'Not Found') }
  end
end

RSpec.describe 'Campaigns', :realistic_error_responses, type: :request do
  include ActiveJob::TestHelper

  let!(:user) { create(:user) }
  let(:jwt_token) { Authorization::JwtEncodeService.build(user).call.data }
  let(:'Authorization') { "Bearer #{jwt_token}" }

  path '/api/v1/campaigns' do
    get 'Receives campaigns' do
      tags 'Campaigns'

      produces 'application/json'

      security [Bearer: []]

      response '200', 'Receives campaigns' do
        let(:service) { Redshift::CampaignQuery }
        let(:service_instance) { instance_double(service) }
        let(:data) { [] }
        let(:service_result) { ServiceResult.new(status: true, data: data) }

        examples(load_examples('application/json', 'v1/examples/campaigns/index'))

        before do
          create_list(:campaign, 2, :with_account, organization: user.organization)

          allow(service).to(receive(:new).with(user.organization.campaigns.pluck(:id))).and_return(service_instance)
          allow(service_instance).to receive(:main_info).and_return(service_result)
        end

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/index')
        end
      end

      it_behaves_like 'Unauthorized request'
    end
  end

  path '/api/v1/campaigns/{id}' do
    get 'Receives campaign' do
      let(:id) { create(:campaign, organization: user.organization).id }

      tags 'Campaigns'

      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'id',
          in: :path,
          type: :integer,
          description: 'Campaign id'
      )

      response '200', 'Receives campaign' do
        examples(load_examples('application/json', 'v1/examples/campaigns/show'))

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/show')
        end
      end

      it_behaves_like 'Unauthorized request'
      it_behaves_like 'Not found'
    end
  end

  path '/api/v1/campaigns' do
    post 'Creates campaign' do
      let(:name) { Faker::Name.unique.name }
      let(:body) do
        {
            campaign: {
                name: name
            }
        }
      end

      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'body',
          in: :body,
          required: true,
          description: 'Campaign body',
          schema: {
              type: :object,
              properties: {
                  campaign: {
                      type: :object,
                      properties: {
                          name: { type: :string },
                          organization_id: { type: :integer },
                          user_defined_status: { type: :string },
                          destination_url: { type: :string },
                          daily_budget: { type: :string },
                          clicks_count: { type: :integer },
                          impressions_count: { type: :integer },
                          wizard_type: { type: :string },
                          start_date: { type: :string },
                          end_date: { type: :string },
                          user_defined_cpm: { type: :string },
                          bidding_strategy: { type: :string },
                          pacing: { type: :string },
                          ecpc_target: { type: :string },
                          max_bid: { type: :string },
                          frequency_cap_impressions: { type: :string },
                          frequency_cap_duration: { type: :string },
                          user_defined_aggressiveness: { type: :string },
                          retargeting_criteria_rules: { type: :string },
                          list_source: { type: :string },
                          user_proposed_total_budget: { type: :string },
                          default_radius_km: { type: :string },
                          deal_ids: {
                              type: :array,
                              items: {
                                  type: :integer
                              }
                          }
                      }
                  }
              }
          }
      )

      response '201', 'Creates campaign' do
        examples(load_examples('application/json', 'v1/examples/campaigns/show'))

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/show')
          expect(parsed_response['name']).to eq(name)
        end
      end

      it_behaves_like 'Unauthorized request'

      response '422', 'Unprocessable entity' do
        let(:end_date) { DateTime.now - 1.day }
        let(:body) do
          {
              campaign: {
                  end_date: end_date
              }
          }
        end

        run_test! do
          expect(response).to match_response_schema('v1/errors')
          expect(response_errors.first['id']).to eq('base')
          expect(response_errors.first['title']).to eq("end_date can't be in the past")
        end
      end
    end
  end

  path '/api/v1/campaigns/{id}' do
    put 'Updates campaign' do
      let(:id) { create(:campaign, organization: user.organization).id }
      let(:name) { Faker::Name.unique.name }
      let(:body) do
        {
            campaign: {
                name: name
            }
        }
      end

      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'id',
          in: :path,
          type: :integer,
          description: 'Campaign id'
      )
      parameter(
          name: 'body',
          in: :body,
          required: true,
          description: 'Campaign body',
          schema: {
              type: :object,
              properties: {
                  campaign: {
                      type: :object,
                      properties: {
                          name: { type: :string },
                          organization_id: { type: :integer },
                          user_defined_status: { type: :string },
                          destination_url: { type: :string },
                          daily_budget: { type: :string },
                          clicks_count: { type: :integer },
                          impressions_count: { type: :integer },
                          wizard_type: { type: :string },
                          start_date: { type: :string },
                          end_date: { type: :string },
                          user_defined_cpm: { type: :string },
                          bidding_strategy: { type: :string },
                          pacing: { type: :string },
                          ecpc_target: { type: :string },
                          max_bid: { type: :string },
                          frequency_cap_impressions: { type: :string },
                          frequency_cap_duration: { type: :string },
                          user_defined_aggressiveness: { type: :string },
                          retargeting_criteria_rules: { type: :string },
                          list_source: { type: :string },
                          user_proposed_total_budget: { type: :string },
                          default_radius_km: { type: :string },
                          deal_ids: {
                              type: :array,
                              items: {
                                  type: :integer
                              }
                          }
                      }
                  }
              }
          }
      )

      response '200', 'Updates campaign' do
        examples(load_examples('application/json', 'v1/examples/campaigns/show'))

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/show')
          expect(parsed_response['name']).to eq(name)
        end
      end

      it_behaves_like 'Unauthorized request'
      it_behaves_like 'Not found'

      response '422', 'Unprocessable entity' do
        let(:end_date) { DateTime.now - 1.day }
        let(:body) do
          {
              campaign: {
                  end_date: end_date
              }
          }
        end

        run_test! do
          expect(response).to match_response_schema('v1/errors')
          expect(response_errors.first['id']).to eq('base')
          expect(response_errors.first['title']).to eq("end_date can't be in the past")
        end
      end
    end
  end

  path '/api/v1/campaigns/{id}/spent_data' do
    get 'Gets spent data' do
      let(:id) { create(:campaign, organization: user.organization).id }
      let(:toDate) { DateTime.now.in_time_zone('Eastern Time (US & Canada)') }
      let(:fromDate) { toDate - 7.days }

      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'id',
          in: :path,
          type: :integer,
          description: 'Campaign id'
      )
      parameter(
          name: 'fromDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Spent data from time parameter'
      )
      parameter(
          name: 'toDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Spent data to time parameter'
      )

      response '200', 'Gets spent data' do
        let(:from_date_parsed) { Time.parse(fromDate.to_s) }
        let(:to_date_parsed) { Time.parse(toDate.to_s) }

        let(:service) { Charts::Redshift::CampaignDeltaDataService }
        let(:service_instance) { instance_double(service) }
        let(:delta_spent) { 0 }
        let(:service_result) { ServiceResult.new(status: true, data: { delta_spent: delta_spent }) }

        examples(load_examples('application/json', 'v1/examples/campaigns/spent_data'))

        before do
          allow(service).to(
              receive(:build)
                  .with(id, from_date: from_date_parsed, to_date: to_date_parsed, columns: :delta_spent)
          ).and_return(service_instance)
          allow(service_instance).to receive(:call).and_return(service_result)
        end

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/spent_data')
          expect(parsed_response['spent_data']).to eq(delta_spent)
        end
      end

      it_behaves_like 'Unauthorized request'
      it_behaves_like 'Not found'
    end
  end

  path '/api/v1/campaigns/update_all_budget' do
    post 'Update all campaigns budget' do
      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'body',
          in: :body,
          required: true,
          schema: {
              type: :object,
              properties: {
                  budget_params: {
                      type: :object,
                      properties: {
                          daily_budget: {
                              type: :number
                          },
                          min_charge_amount: {
                              type: :number
                          },
                          bidding_strategy: {
                              type: :string
                          },
                          user_defined_cpm: {
                              type: :number
                          },
                          pacing: {
                              type: :string
                          },
                          max_bid: {
                              type: :number
                          },
                          ecpc_target: {
                              type: :number
                          },
                          segment_extension_default: {
                              type: :string
                          },
                          user_defined_aggressiveness: {
                              type: :number
                          }
                      }
                  }
              }
          }
      )

      response '202', 'Campaigns updates are added to processing' do
        let(:body) do
          {
              budget_params: {
                  daily_budget: 2.0,
                  min_charge_amount: 3.0,
                  bidding_strategy: 'CPM_PACED',
                  user_defined_cpm: 2,
                  pacing: 'lifetime',
                  max_bid: 0.01,
                  ecpc_target: 0.01,
                  segment_extension_default: 'segment_extension_default',
                  user_defined_aggressiveness: 40
              }
          }
        end

        run_test! { expect(parsed_response['job_id']).not_to be_empty }
      end

      it_behaves_like 'Unauthorized request'
    end
  end

  path '/api/v1/campaigns/update_all_options' do
    post 'Update all campaigns options' do
      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'body',
          in: :body,
          required: true,
          schema: {
              type: :object,
              properties: {
                  options_params: {
                      type: :object,
                      properties: {
                          start_date: {
                              type: :string
                          },
                          end_date: {
                              type: :string
                          },
                          frequency_cap_impressions: {
                              type: :integer
                          },
                          frequency_cap_duration: {
                              type: :integer
                          },
                          default_radius_km: {
                              type: :number
                          },
                          geo_optimizations: {
                              type: :array,
                              items: {
                                  type: :object,
                                  properties: {
                                      seeded_bw_country_id: {
                                          type: :integer
                                      }
                                  }
                              }
                          },
                          day_partings: {
                              type: :array,
                              items: {
                                  type: :object,
                                  properties: {
                                      day: {
                                          type: :integer
                                      },
                                      from_hour: {
                                          type: :integer
                                      },
                                      to_hour: {
                                          type: :integer
                                      }
                                  }
                              }
                          },
                          continents: {
                              type: :array,
                              items: {
                                  type: :object,
                                  properties: {
                                      name: {
                                          type: :string
                                      }
                                  }
                              }
                          }
                      }
                  }
              }
          }
      )

      response '202', 'Campaigns updates are added to processing' do
        let(:body) do
          {
              options_params: {
                  start_date: '2020-05-20',
                  end_date: '2020-05-21',
                  frequency_cap_impressions: 25,
                  frequency_cap_duration: 3700,
                  default_radius_km: 0.2,
                  geo_optimizations: [{ seeded_bw_country_id: 1 }],
                  day_partings: [{ day: 2, from_hour: 12, to_hour: 14 }],
                  continents: [{ name: 'NAM'}]
              }
          }
        end

        run_test! { expect(parsed_response['job_id']).not_to be_empty }
      end

      it_behaves_like 'Unauthorized request'
    end
  end

  path '/api/v1/campaigns/update_all_inventories' do
    post 'Update all campaigns options' do
      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'body',
          in: :body,
          required: true,
          schema: {
              type: :object,
              properties: {
                  inventories_params: {
                      type: :object,
                      properties: {
                          inventories: {
                              type: :array,
                              items: {
                                  type: :object,
                                  properties: {
                                      seeded_inventory_source_id: {
                                          type: :integer
                                      }
                                  }
                              }
                          }
                      }
                  }
              }
          }
      )

      response '202', 'Campaigns updates are added to processing' do
        let(:body) do
          {
              inventories_params: {
                  inventories: [{ seeded_inventory_source_id: 1 }]
              }
          }
        end

        run_test! { expect(parsed_response['job_id']).not_to be_empty }
      end

      it_behaves_like 'Unauthorized request'
    end
  end

  path '/api/v1/campaigns/{id}/impressions_data' do
    get 'Gets impressions data' do
      let(:id) { create(:campaign, organization: user.organization).id }
      let(:toDate) { DateTime.now.in_time_zone('Eastern Time (US & Canada)') }
      let(:fromDate) { toDate - 7.days }

      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'id',
          in: :path,
          type: :integer,
          description: 'Campaign id'
      )
      parameter(
          name: 'fromDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Impressions data from time parameter'
      )
      parameter(
          name: 'toDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Impressions data to time parameter'
      )
      parameter(
          name: 'offset',
          in: :query,
          required: false,
          type: :integer,
          description: 'Items offset'
      )
      parameter(
          name: 'limit',
          in: :query,
          required: false,
          type: :integer,
          description: 'Items limit'
      )
      parameter(
          name: 'filters',
          in: :query,
          required: false,
          type: :array,
          description: 'Items filter'
      )

      response '200', 'Gets impressions data' do
        let(:service) { Reporting::Records::ImpressionsService }
        let(:service_instance) { instance_double(service) }
        let(:service_result) do
          ServiceResult.new(
              status: true,
              data: service_data
          )
        end
        let(:service_data) do
          [
              {
                  id: Faker::Number.digit,
                  account_id: Faker::Number.digit,
                  account_name: Faker::Lorem.word,
                  account_domain: Faker::Internet.domain_name,
                  campaign_id: Faker::Number.digit,
                  campaign_name: Faker::Lorem.word,
                  job_title_name: Faker::Lorem.word,
                  organization_id: Faker::Number.digit,
                  organization_name: Faker::Lorem.word,
                  rx_timestamp: Faker::Time.backward.to_s,
                  site_name: Faker::Internet.domain_name,
                  app_name: Faker::Lorem.word,
                  domain: Faker::Internet.domain_name,
                  ll_creative_id: Faker::Number.digit,
                  creative_name: Faker::Lorem.word,
                  creative_tag: Faker::Lorem.word,
                  creative_size: "#{Faker::Number.digit}x#{Faker::Number.digit}",
                  clicks: Faker::Number.digit,
                  ip_address: Faker::Internet.ip_v4_address,
                  account_list: Faker::Lorem.word,
                  bid_hour: Faker::Time.backward.to_s,
                  ad_position: Faker::Lorem.word,
                  app_bundle: Faker::Lorem.word,
                  category: Faker::Lorem.word,
                  content_language: Faker::Lorem.word,
                  content_rating: Faker::Lorem.word,
                  conversions: Faker::Lorem.word,
                  environment_type: Faker::Lorem.word,
                  geo_city: Faker::Address.city,
                  geo_country: Faker::Address.country,
                  geo_metro: Faker::Lorem.word,
                  geo_region: Faker::Lorem.word,
                  geo_zip: Faker::Lorem.word,
                  placement: Faker::Lorem.word,
                  platform_browser: Faker::Lorem.word,
                  platform_browser_version: Faker::Lorem.word,
                  platform_carrier: Faker::Lorem.word,
                  platform_device_make: Faker::Lorem.word,
                  platform_device_model: Faker::Lorem.word,
                  platform_device_type: Faker::Lorem.word,
                  platform_os: Faker::Lorem.word,
                  platform_os_version: Faker::Lorem.word,
                  geo_lat: Faker::Address.latitude.to_s,
                  geo_lon: Faker::Address.longitude.to_s,
                  inventory_source: Faker::Lorem.word,
                  video_completes: Faker::Lorem.word,
                  video_midpoints: Faker::Lorem.word,
                  video_playback_method: Faker::Lorem.word,
                  video_player_size: Faker::Lorem.word,
                  video_plays: Faker::Lorem.word,
                  video_q1s: Faker::Lorem.word,
                  video_q3s: Faker::Lorem.word,
                  video_skips: Faker::Lorem.word,
                  video_start_delay: Faker::Lorem.word,
                  in_view: Faker::Lorem.word,
                  in_view_time_millis: Faker::Lorem.word,
                  is_measurable: Faker::Lorem.word,
                  win_cost_micros: Faker::Number.digit
              }
          ]
        end

        let(:from_date_parsed) { Time.parse(fromDate.to_s) }
        let(:to_date_parsed) { Time.parse(toDate.to_s) }

        examples(load_examples('application/json', 'v1/examples/campaigns/impressions_data'))

        before do
          allow(service).to(
              receive(:build)
                  .with(
                      organization_ids: [user.organization.id],
                      campaign_ids: [id],
                      from_date: from_date_parsed,
                      to_date: to_date_parsed,
                      offset: 0,
                      limit: 100,
                      filters: [],
                      consumer: :client
                  )
          ).and_return(service_instance)
          allow(service_instance).to receive(:call).and_return(service_result)
        end

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/impressions_data')
          expect(parsed_response).to eq([service_data.first.transform_keys(&:to_s)])
        end
      end

      it_behaves_like 'Unauthorized request'
      it_behaves_like 'Not found'
    end
  end

  path '/api/v1/campaigns/{id}/page_views_data' do
    get 'Gets page views data' do
      let(:id) { create(:campaign, organization: user.organization).id }
      let(:toDate) { DateTime.now.in_time_zone('Eastern Time (US & Canada)') }
      let(:fromDate) { toDate - 7.days }

      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'id',
          in: :path,
          type: :integer,
          description: 'Campaign id'
      )
      parameter(
          name: 'fromDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Page views data from time parameter'
      )
      parameter(
          name: 'toDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Page views data to time parameter'
      )
      parameter(
          name: 'offset',
          in: :query,
          required: false,
          type: :integer,
          description: 'Items offset'
      )
      parameter(
          name: 'limit',
          in: :query,
          required: false,
          type: :integer,
          description: 'Items limit'
      )
      parameter(
          name: 'filters',
          in: :query,
          required: false,
          type: :array,
          description: 'Items filter'
      )

      response '200', 'Gets page views data' do
        let(:service) { PaginatedIndex::PageViewsService }
        let(:service_instance) { instance_double(service) }
        let(:page_view) { create(:page_view) }
        let(:page_views) { [page_view] }
        let(:service_result) do
          ServiceResult.new(status: true, data: page_views)
        end

        let(:from_date_parsed) { Time.parse(fromDate.to_s) }
        let(:to_date_parsed) { Time.parse(toDate.to_s) }

        examples(load_examples('application/json', 'v1/examples/campaigns/page_views_data'))

        before do
          allow(service).to(
              receive(:build).with(id, from_date_parsed, to_date_parsed, 0, 100, [])
          ).and_return(service_instance)
          allow(service_instance).to receive(:call).and_return(service_result)
        end

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/page_views_data')
        end
      end

      it_behaves_like 'Unauthorized request'
      it_behaves_like 'Not found'
    end
  end

  path '/api/v1/campaigns/{id}/conversion_criteria_data' do
    get 'Gets conversion criteria data' do
      let(:id) { create(:campaign, organization: user.organization).id }
      let(:toDate) { DateTime.now.in_time_zone('Eastern Time (US & Canada)') }
      let(:fromDate) { toDate - 7.days }

      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'id',
          in: :path,
          type: :integer,
          description: 'Campaign id'
      )
      parameter(
          name: 'fromDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Conversion criteria data from time parameter'
      )
      parameter(
          name: 'toDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Conversion criteria data to time parameter'
      )
      parameter(
          name: 'offset',
          in: :query,
          required: false,
          type: :integer,
          description: 'Items offset'
      )
      parameter(
          name: 'limit',
          in: :query,
          required: false,
          type: :integer,
          description: 'Items limit'
      )

      response '200', 'Gets conversion criteria data' do
        let(:service) { Reporting::Records::ConversionCriteriaService }
        let(:service_instance) { instance_double(service) }
        let(:data) { [create(:conversion_criterium)] }
        let(:service_result) { ServiceResult.new(status: true, data: data) }

        let(:from_date_parsed) { Time.parse(fromDate.to_s) }
        let(:to_date_parsed) { Time.parse(toDate.to_s) }

        examples(
            load_examples('application/json', 'v1/examples/campaigns/conversion_criteria_data')
        )

        before do
          allow(service).to(
              receive(:build).with(
                  campaign_ids: [id],
                  from_date: from_date_parsed,
                  to_date: to_date_parsed,
                  offset: 0,
                  limit: 100
              )
          ).and_return(service_instance)
          allow(service_instance).to receive(:call).and_return(service_result)
        end

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/conversion_criteria_data')
        end
      end

      it_behaves_like 'Unauthorized request'
      it_behaves_like 'Not found'
    end
  end

  path '/api/v1/campaigns/{id}/personalization_criteria_data' do
    get 'Gets personalization criteria data' do
      let(:id) { create(:campaign, organization: user.organization).id }
      let(:toDate) { DateTime.now.in_time_zone('Eastern Time (US & Canada)') }
      let(:fromDate) { toDate - 7.days }

      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'id',
          in: :path,
          type: :integer,
          description: 'Campaign id'
      )
      parameter(
          name: 'fromDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Personalization criteria data from time parameter'
      )
      parameter(
          name: 'toDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Personalization criteria data to time parameter'
      )
      parameter(
          name: 'offset',
          in: :query,
          required: false,
          type: :integer,
          description: 'Items offset'
      )
      parameter(
          name: 'limit',
          in: :query,
          required: false,
          type: :integer,
          description: 'Items limit'
      )

      response '200', 'Receives personalization criteria data' do
        let(:service) { Reporting::Records::PersonalizationCriteriaService }
        let(:service_instance) { instance_double(service) }
        let(:service_data) { [create(:personalization_criterium)] }
        let(:service_result) { ServiceResult.new(status: true, data: service_data) }

        let(:from_date_parsed) { Time.parse(fromDate.to_s) }
        let(:to_date_parsed) { Time.parse(toDate.to_s) }

        examples(
            load_examples('application/json', 'v1/examples/campaigns/personalization_criteria_data')
        )

        before do
          allow(service).to(
              receive(:build).with(
                  campaign_ids: [id],
                  from_date: from_date_parsed,
                  to_date: to_date_parsed,
                  offset: 0,
                  limit: 100
              ).and_return(service_instance)
          )
          allow(service_instance).to receive(:call).and_return(service_result)
        end

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/personalization_criteria_datas')
        end
      end

      it_behaves_like 'Unauthorized request'
      it_behaves_like 'Not found'
    end
  end

  path '/api/v1/campaigns/{id}/influenced_accounts' do
    get 'Gets influenced accounts data' do
      let(:id) { create(:campaign, organization: user.organization).id }
      let(:toDate) { DateTime.now.in_time_zone('Eastern Time (US & Canada)') }
      let(:fromDate) { toDate - 7.days }

      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'id',
          in: :path,
          type: :integer,
          description: 'Campaign id'
      )
      parameter(
          name: 'fromDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Influenced accounts data from time parameter'
      )
      parameter(
          name: 'toDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Influenced accounts data to time parameter'
      )

      response '200', 'Receives influenced accounts data' do
        let(:service) { Charts::Redshift::CampaignDeltaDataService }
        let(:service_instance) { instance_double(service) }
        let(:service_data) do
          { delta_accounts_influenced: [[Faker::Date.backward, Faker::Number.digit]] }
        end
        let(:service_result) { ServiceResult.new(status: true, data: service_data) }

        let(:from_date_parsed) { Time.parse(fromDate.to_s) }
        let(:to_date_parsed) { Time.parse(toDate.to_s) }

        examples(load_examples('application/json', 'v1/examples/campaigns/influenced_accounts'))

        before do
          allow(service).to(
              receive(:build).with(
                  id,
                  from_date: from_date_parsed,
                  to_date: to_date_parsed,
                  columns: :delta_accounts_influenced
              )
          ).and_return(service_instance)
          allow(service_instance).to receive(:call).and_return(service_result)
        end

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/influenced_accounts')
        end
      end

      it_behaves_like 'Unauthorized request'
      it_behaves_like 'Not found'
    end
  end

  path '/api/v1/campaigns/{id}/chart_data' do
    get 'Gets chart data' do
      let(:id) { create(:campaign, organization: user.organization).id }
      let(:toDate) { DateTime.now.in_time_zone('Eastern Time (US & Canada)') }
      let(:fromDate) { toDate - 7.days }

      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'id',
          in: :path,
          type: :integer,
          description: 'Campaign id'
      )
      parameter(
          name: 'fromDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Chart data from time parameter'
      )
      parameter(
          name: 'toDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Chart data data to time parameter'
      )

      response '200', 'Receives chart data' do
        let(:service) { Charts::Redshift::CampaignDeltaDataService }
        let(:service_instance) { instance_double(service) }
        let(:service_result) { ServiceResult.new(status: true, data: service_data) }
        let(:service_data) do
          {
              delta_impressions: [[Faker::Date.backward, Faker::Number.digit]],
              delta_clicks: [[Faker::Date.backward, Faker::Number.digit]],
              delta_page_views: [[Faker::Date.backward, Faker::Number.digit]],
              delta_personalization_c_page_views: [[Faker::Date.backward, Faker::Number.digit]],
              delta_conversion_c_page_views: [[Faker::Date.backward, Faker::Number.digit]],
              delta_spent: [[Faker::Date.backward, Faker::Number.digit]],
              delta_accounts_influenced: [[Faker::Date.backward, Faker::Number.digit]],
              delta_ctr: [[Faker::Date.backward, Faker::Number.digit]],
              delta_conversion_rate: [[Faker::Date.backward, Faker::Number.digit]]
          }
        end

        let(:from_date_parsed) { Time.parse(fromDate.to_s) }
        let(:to_date_parsed) { Time.parse(toDate.to_s) }

        examples(load_examples('application/json', 'v1/examples/campaigns/chart_data'))

        before do
          allow(service).to(
              receive(:build).with(
                  id,
                  from_date: from_date_parsed,
                  to_date: to_date_parsed,
                  columns: Constants::CAMPAIGN_CHART_COLUMNS,
                  limit: 100,
                  offset: 0
              )
          ).and_return(service_instance)
          allow(service_instance).to receive(:call).and_return(service_result)
        end

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/chart_data')
        end
      end

      it_behaves_like 'Unauthorized request'
      it_behaves_like 'Not found'
    end
  end

  path '/api/v1/campaigns/{id}/total_chart_data' do
    get 'Gets total chart data' do
      let(:id) { create(:campaign, organization: user.organization).id }
      let(:toDate) { DateTime.now.in_time_zone('Eastern Time (US & Canada)') }
      let(:fromDate) { toDate - 7.days }

      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'id',
          in: :path,
          type: :integer,
          description: 'Campaign id'
      )
      parameter(
          name: 'fromDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Chart data from time parameter'
      )
      parameter(
          name: 'toDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Chart data data to time parameter'
      )

      response '200', 'Receives total chart data' do
        let(:service) { Charts::Redshift::CampaignTotalDataService }
        let(:service_instance) { instance_double(service) }
        let(:service_result) { ServiceResult.new(status: true, data: service_data) }
        let(:service_data) do
          {
              total_impressions: [[Faker::Date.backward, Faker::Number.digit]],
              total_clicks: [[Faker::Date.backward, Faker::Number.digit]],
              total_page_views: [[Faker::Date.backward, Faker::Number.digit]],
              total_personalization_c_page_views: [[Faker::Date.backward, Faker::Number.digit]],
              total_conversion_c_page_views: [[Faker::Date.backward, Faker::Number.digit]],
              total_spent: [[Faker::Date.backward, Faker::Number.digit]],
              total_accounts_influenced: [[Faker::Date.backward, Faker::Number.digit]],
              total_ctr: [[Faker::Date.backward, Faker::Number.digit]],
              total_conversion_rate: [[Faker::Date.backward, Faker::Number.digit]]
          }
        end

        let(:from_date_parsed) { Time.parse(fromDate.to_s) }
        let(:to_date_parsed) { Time.parse(toDate.to_s) }

        examples(load_examples('application/json', 'v1/examples/campaigns/total_chart_data'))

        before do
          allow(service).to(
              receive(:build).with(
                  id,
                  from_date: from_date_parsed,
                  to_date: to_date_parsed,
                  columns: Constants::CAMPAIGN_TOTAL_CHART_COLUMNS
              )
          ).and_return(service_instance)
          allow(service_instance).to receive(:call).and_return(service_result)
        end

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/total_chart_data')
        end
      end

      it_behaves_like 'Unauthorized request'
      it_behaves_like 'Not found'
    end
  end

  path '/api/v1/campaigns/list_with_reporting_numbers' do
    get 'Gets list with reporting numbers data' do
      let(:toDate) { DateTime.now.in_time_zone('Eastern Time (US & Canada)') }
      let(:fromDate) { toDate - 7.days }

      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'fromDate',
          in: :query,
          required: true,
          type: :string,
          description: 'List with reporting numbers data from time parameter'
      )
      parameter(
          name: 'toDate',
          in: :query,
          required: true,
          type: :string,
          description: 'List with reporting numbers data data to time parameter'
      )

      response '200', 'Gets list with reporting numbers data' do
        let(:service) { Reporting::Records::CampaignsService }
        let(:service_instance) { instance_double(service) }
        let(:service_result) { ServiceResult.new(status: true, data: service_data) }
        let(:service_data) do
          [
              {
                  'id' => Faker::Number.digit,
                  'name' => Faker::Lorem.word,
                  'accounts_count' => Faker::Number.digit,
                  'turned_on' => Faker::Number.digit,
                  'impressions_count' => Faker::Number.digit,
                  'clicks_count' => Faker::Number.digit,
                  'ctr' => Faker::Number.decimal,
                  'win_budget_spent' => Faker::Number.decimal,
                  'revenue_budget_spent' => Faker::Number.decimal,
                  'page_views_count' => Faker::Number.digit,
                  'personalization_c_page_views_count' => Faker::Number.digit,
                  'conversion_c_page_views_count' => Faker::Number.digit,
                  'duration_sum' => Faker::Number.digit,
                  'conversion_rate' => Faker::Number.decimal,
                  'created_at' => Faker::Date.backward,
                  'start_date' => Faker::Date.backward,
                  'end_date' => Faker::Date.backward,
                  'daily_budget' => Faker::Number.decimal,
                  'user_defined_status' => Faker::Number.digit,
                  'accounts_influenced' => Faker::Number.digit
              }
          ]
        end

        let(:from_date_parsed) { Time.parse(fromDate.to_s) }
        let(:to_date_parsed) { Time.parse(toDate.to_s) }

        examples(
            load_examples('application/json', 'v1/examples/campaigns/list_with_reporting_numbers')
        )

        before do
          allow(service).to(
              receive(:build).with(
                  organization_ids: [user.organization.id],
                  from_date: from_date_parsed,
                  to_date: to_date_parsed
              )
          ).and_return(service_instance)
          allow(service_instance).to receive(:call).and_return(service_result)
        end

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/list_with_reporting_numbers')
        end
      end

      it_behaves_like 'Unauthorized request'
    end
  end

  path '/api/v1/campaigns/{id}/show_with_reporting_numbers' do
    get 'Gets show with reporting numbers data' do
      let(:id) { create(:campaign, organization: user.organization).id }
      let(:toDate) { DateTime.now.in_time_zone('Eastern Time (US & Canada)') }
      let(:fromDate) { toDate - 7.days }

      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'id',
          in: :path,
          type: :integer,
          description: 'Campaign id'
      )
      parameter(
          name: 'fromDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Show with reporting numbers data from time parameter'
      )
      parameter(
          name: 'toDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Show with reporting numbers data to time parameter'
      )

      response '200', 'Gets show with reporting numbers data' do
        let(:service) { Reporting::Records::CampaignsService }
        let(:service_instance) { instance_double(service) }
        let(:service_result) { ServiceResult.new(status: true, data: service_data) }
        let(:service_data) do
          [
              {
                  'id' => Faker::Number.digit,
                  'name' => Faker::Lorem.word,
                  'accounts_count' => Faker::Number.digit,
                  'turned_on' => Faker::Number.digit,
                  'impressions_count' => Faker::Number.digit,
                  'clicks_count' => Faker::Number.digit,
                  'ctr' => Faker::Number.decimal,
                  'win_budget_spent' => Faker::Number.decimal,
                  'revenue_budget_spent' => Faker::Number.decimal,
                  'page_views_count' => Faker::Number.digit,
                  'personalization_c_page_views_count' => Faker::Number.digit,
                  'conversion_c_page_views_count' => Faker::Number.digit,
                  'duration_sum' => Faker::Number.digit,
                  'conversion_rate' => Faker::Number.decimal,
                  'created_at' => Faker::Date.backward,
                  'start_date' => Faker::Date.backward,
                  'end_date' => Faker::Date.backward,
                  'daily_budget' => Faker::Number.decimal,
                  'user_defined_status' => Faker::Number.digit,
                  'accounts_influenced' => Faker::Number.digit
              }
          ]
        end

        let(:from_date_parsed) { Time.parse(fromDate.to_s) }
        let(:to_date_parsed) { Time.parse(toDate.to_s) }

        examples(
            load_examples('application/json', 'v1/examples/campaigns/show_with_reporting_numbers')
        )

        before do
          allow(service).to(
              receive(:build).with(
                  campaign_ids: [id],
                  from_date: from_date_parsed,
                  to_date: to_date_parsed
              )
          ).and_return(service_instance)
          allow(service_instance).to receive(:call).and_return(service_result)
        end

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/show_with_reporting_numbers')
        end
      end

      it_behaves_like 'Unauthorized request'
      it_behaves_like 'Not found'
    end
  end

  path '/api/v1/campaigns/{id}/email_impressions_data' do
    post 'Emails impressions data' do
      let(:id) { create(:campaign, organization: user.organization).id }
      let(:toDate) { DateTime.now.in_time_zone('Eastern Time (US & Canada)') }
      let(:fromDate) { toDate - 7.days }

      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'id',
          in: :path,
          type: :integer,
          description: 'Campaign id'
      )
      parameter(
          name: 'fromDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Impressions data email from time parameter'
      )
      parameter(
          name: 'toDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Impressions data email to time parameter'
      )

      response '202', 'Sends impressions data email' do
        let(:mailer_job) { MailerJob }
        let(:mailer_job_set_params) { { wait: ENV['JOB_WAIT_IN_SECONDS'].to_i.seconds } }
        let(:mailer_job_instance) { instance_double(mailer_job) }
        let(:configured_job_instance) { instance_double(ActiveJob::ConfiguredJob) }
        let(:impressions_report_service_params) do
          {
              report_type: 'impressions_report',
              organization_ids: [user.organization.id],
              campaign_ids: [id],
              from_date: from_date_parsed,
              to_date: to_date_parsed,
              email: user.email
          }
        end
        let(:job_id) { SecureRandom.uuid }

        let(:from_date_parsed) { Time.parse(fromDate.to_s) }
        let(:to_date_parsed) { Time.parse(toDate.to_s) }

        examples(load_examples('application/json', 'v1/examples/campaigns/job_id_response'))

        before do
          allow(mailer_job).to(
              receive(:set).with(mailer_job_set_params)
          ).and_return(configured_job_instance)
          allow(configured_job_instance).to(
              receive(:perform_later)
                  .with('Reporting::Email::Clients::EmailService', impressions_report_service_params)
          ).and_return(mailer_job_instance)
          allow(mailer_job_instance).to receive(:job_id).and_return(job_id)
        end

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/job_id_response')
          expect(mailer_job).to have_received(:set).with(mailer_job_set_params)
          expect(configured_job_instance).to(
              have_received(:perform_later)
                  .with('Reporting::Email::Clients::EmailService', impressions_report_service_params)
          )
          expect(parsed_response['job_id']).to eq(job_id)
        end
      end

      it_behaves_like 'Unauthorized request'
      it_behaves_like 'Not found'
    end
  end

  path '/api/v1/campaigns/{id}/email_clicks_data' do
    post 'Emails clicks data' do
      let(:id) { create(:campaign, organization: user.organization).id }
      let(:toDate) { DateTime.now.in_time_zone('Eastern Time (US & Canada)') }
      let(:fromDate) { toDate - 7.days }

      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'id',
          in: :path,
          type: :integer,
          description: 'Campaign id'
      )
      parameter(
          name: 'fromDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Clicks data email from time parameter'
      )
      parameter(
          name: 'toDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Clicks data email to time parameter'
      )

      response '202', 'Sends clicks data email' do
        let(:mailer_job) { MailerJob }
        let(:mailer_job_set_params) { { wait: ENV['JOB_WAIT_IN_SECONDS'].to_i.seconds } }
        let(:mailer_job_instance) { instance_double(mailer_job) }
        let(:configured_job_instance) { instance_double(ActiveJob::ConfiguredJob) }
        let(:clicks_report_service_params) do
          {
              report_type: 'clicks_report',
              organization_ids: [user.organization.id],
              campaign_ids: [id],
              from_date: from_date_parsed,
              to_date: to_date_parsed,
              email: user.email
          }
        end
        let(:job_id) { SecureRandom.uuid }

        let(:from_date_parsed) { Time.parse(fromDate.to_s) }
        let(:to_date_parsed) { Time.parse(toDate.to_s) }

        examples(load_examples('application/json', 'v1/examples/campaigns/job_id_response'))

        before do
          allow(mailer_job).to(
              receive(:set).with(mailer_job_set_params)
          ).and_return(configured_job_instance)
          allow(configured_job_instance).to(
              receive(:perform_later)
                  .with('Reporting::Email::Clients::EmailService', clicks_report_service_params)
          ).and_return(mailer_job_instance)
          allow(mailer_job_instance).to receive(:job_id).and_return(job_id)
        end

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/job_id_response')
          expect(mailer_job).to have_received(:set).with(mailer_job_set_params)
          expect(configured_job_instance).to(
              have_received(:perform_later)
                  .with('Reporting::Email::Clients::EmailService', clicks_report_service_params)
          )
          expect(parsed_response['job_id']).to eq(job_id)
        end
      end

      it_behaves_like 'Unauthorized request'
      it_behaves_like 'Not found'
    end
  end

  path '/api/v1/campaigns/{id}/email_page_views_data' do
    post 'Emails page views data' do
      let(:id) { create(:campaign, organization: user.organization).id }
      let(:toDate) { DateTime.now.in_time_zone('Eastern Time (US & Canada)') }
      let(:fromDate) { toDate - 7.days }

      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'id',
          in: :path,
          type: :integer,
          description: 'Campaign id'
      )
      parameter(
          name: 'fromDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Page views data email from time parameter'
      )
      parameter(
          name: 'toDate',
          in: :query,
          required: true,
          type: :string,
          description: 'Page views data email to time parameter'
      )

      response '202', 'Sends page views email' do
        let(:mailer_job) { MailerJob }
        let(:mailer_job_set_params) { { wait: ENV['JOB_WAIT_IN_SECONDS'].to_i.seconds } }
        let(:mailer_job_instance) { instance_double(mailer_job) }
        let(:configured_job_instance) { instance_double(ActiveJob::ConfiguredJob) }
        let(:page_views_report_service_params) do
          {
              report_type: 'page_views_report',
              organization_ids: [user.organization.id],
              campaign_ids: [id],
              from_date: from_date_parsed,
              to_date: to_date_parsed,
              email: user.email
          }
        end
        let(:job_id) { SecureRandom.uuid }

        let(:from_date_parsed) { Time.parse(fromDate.to_s) }
        let(:to_date_parsed) { Time.parse(toDate.to_s) }

        examples(load_examples('application/json', 'v1/examples/campaigns/job_id_response'))

        before do
          allow(mailer_job).to(
              receive(:set).with(mailer_job_set_params)
          ).and_return(configured_job_instance)
          allow(configured_job_instance).to(
              receive(:perform_later)
                  .with('Reporting::Email::Clients::EmailService', page_views_report_service_params)
          ).and_return(mailer_job_instance)
          allow(mailer_job_instance).to receive(:job_id).and_return(job_id)
        end

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/job_id_response')
          expect(mailer_job).to have_received(:set).with(mailer_job_set_params)
          expect(configured_job_instance).to(
              have_received(:perform_later)
                  .with('Reporting::Email::Clients::EmailService', page_views_report_service_params)
          )
          expect(parsed_response['job_id']).to eq(job_id)
        end
      end

      it_behaves_like 'Unauthorized request'
      it_behaves_like 'Not found'
    end
  end

  path '/api/v1/campaigns/{id}/clone' do
    post 'Clones campaign' do
      let(:id) { create(:campaign, organization: user.organization).id }

      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'id',
          in: :path,
          type: :integer,
          description: 'Campaign id'
      )
      parameter(
          name: 'body',
          in: :body,
          required: true,
          description: 'Campaign body',
          schema: {
              type: :object,
              properties: {
                  campaign: {
                      type: :object,
                      properties: {
                          name: { type: :string },
                          organization_id: { type: :integer },
                          user_defined_status: { type: :string },
                          destination_url: { type: :string },
                          daily_budget: { type: :string },
                          clicks_count: { type: :integer },
                          impressions_count: { type: :integer },
                          wizard_type: { type: :string },
                          start_date: { type: :string },
                          end_date: { type: :string },
                          user_defined_cpm: { type: :string },
                          bidding_strategy: { type: :string },
                          pacing: { type: :string },
                          ecpc_target: { type: :string },
                          max_bid: { type: :string },
                          frequency_cap_impressions: { type: :string },
                          frequency_cap_duration: { type: :string },
                          user_defined_aggressiveness: { type: :string },
                          retargeting_criteria_rules: { type: :string },
                          list_source: { type: :string },
                          user_proposed_total_budget: { type: :string },
                          default_radius_km: { type: :string },
                          deal_ids: {
                              type: :array,
                              items: {
                                  type: :integer
                              }
                          }
                      }
                  },
                  information_to_clone: {
                      type: :object,
                      properties: {
                          accounts: { type: :boolean },
                          job_titles: { type: :boolean },
                          destination_url: { type: :boolean },
                          ad_budget: { type: :boolean },
                          conversions: { type: :boolean },
                          creatives: { type: :boolean },
                      }
                  }
              }
          }
      )

      response '202', 'Clones campaign' do
        let(:name) { Faker::Name.unique.name }
        let(:campaign_params) { { 'name' => name } }
        let(:information_to_clone_params) { { 'accounts' => true } }
        let(:body) do
          {
              campaign: campaign_params,
              information_to_clone: information_to_clone_params
          }
        end

        let(:default_job) { DefaultJob }
        let(:default_job_set_params) { { wait: ENV['JOB_WAIT_IN_SECONDS'].to_i.seconds } }
        let(:default_job_instance) { instance_double(default_job) }
        let(:job_id) { SecureRandom.uuid }
        let(:configured_job_instance) { instance_double(ActiveJob::ConfiguredJob) }

        examples(load_examples('application/json', 'v1/examples/campaigns/job_id_response'))

        before do
          allow(default_job).to(
              receive(:set).with(default_job_set_params)
          ).and_return(configured_job_instance)
          allow(configured_job_instance).to(
              receive(:perform_later).with(
                  'Campaigns::CloneService', id.to_s, campaign_params, information_to_clone_params
              )
          ).and_return(default_job_instance)
          allow(default_job_instance).to receive(:job_id).and_return(job_id)
        end

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/job_id_response')
          expect(default_job).to have_received(:set).with(default_job_set_params)
          expect(configured_job_instance).to(
              have_received(:perform_later)
                  .with('Campaigns::CloneService', id.to_s, campaign_params, information_to_clone_params)
          )
          expect(parsed_response['job_id']).to eq(job_id)
        end
      end

      it_behaves_like 'Unauthorized request'
      it_behaves_like 'Not found'
    end
  end

  path '/api/v1/campaigns/archived' do
    get 'Gets archived campaigns' do
      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      response '200', 'Receives archived campaigns' do
        examples(load_examples('application/json', 'v1/examples/campaigns/archived'))

        before do
          create_list(:campaign, 2, organization: user.organization, user_defined_status: :archived)
        end

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/archived')
          expect(parsed_response.count).to eq(2)
        end
      end

      it_behaves_like 'Unauthorized request'
    end
  end

  path '/api/v1/campaigns/update_all_csv_lists' do
    post 'Update all campaigns csv_lists' do
      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'body',
          in: :body,
          required: true,
          schema: {
              type: :object,
              properties: {
                  campaign_ids: {
                      type: :array,
                      items: { type: :integer }
                  },
                  csv_lists_params: {
                      type: :object,
                      properties: {
                          csv_lists_clear_all: { type: :boolean },
                          csv_list_ids: {
                              type: :array,
                              items: { type: :integer }
                          }
                      }
                  }
              }
          }
      )

      response '202', 'Campaigns updates are added to processing' do
        let!(:campaign_ids) { create_list(:campaign, 2, organization: user.organization).map(&:id) }
        let!(:csv_list_ids) { create_list(:csv_list, 2, organization: user.organization).map(&:id) }
        let(:body) do
          {
              campaign_ids: campaign_ids,
              csv_lists_params: {
                  csv_list_ids: csv_list_ids,
                  csv_lists_clear_all: Faker::Boolean.boolean
              }
          }
        end

        examples(load_examples('application/json', 'v1/examples/campaigns/job_id_response'))

        run_test! do
          expect(
              ActiveJob::Base.queue_adapter.enqueued_jobs.select do |job|
                job[:job] == DefaultJob && job[:args].first == Campaigns::BulkCsvListsUpdateService.name
              end.count
          ).to eq(1)

          expect(parsed_response['job_id']).not_to be_empty
        end
      end

      it_behaves_like 'Unauthorized request'
    end
  end

  path '/api/v1/campaigns/unique_job_titles_for_campaigns' do
    get 'Gets unique job_titles for campaigns' do
      let(:campaigns) { create_list(:campaign, 2, organization: user.organization) }
      let(:campaign_ids) { campaigns.map(&:id) }

      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'campaign_ids',
          in: :query,
          type: :array,
          description: 'Campaign ids'
      )

      response '200', 'Receives unique job_titles for campaigns' do
        examples(
            load_examples(
                'application/json',
                'v1/examples/campaigns/unique_job_titles_for_campaigns'
            )
        )

        before do
          create_list(:job_title, 2, campaign: campaigns.first)
          create_list(:job_title, 2, campaign: campaigns.last)
        end

        run_test! do
          expect(response).to match_response_schema('v1/campaigns/unique_job_titles_for_campaigns')
          expect(parsed_response.count).to eq(2)
        end
      end

      it_behaves_like 'Unauthorized request'
    end
  end

  path '/api/v1/campaigns/update_all_job_titles' do
    post 'Update all campaigns job titles' do
      tags 'Campaigns'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: []]

      parameter(
          name: 'body',
          in: :body,
          required: true,
          schema: {
              type: :object,
              properties: {
                  job_titles_params: {
                      type: :object,
                      properties: {
                          campaign_ids: {
                              type: :array,
                              items: {
                                  type: :integer
                              }
                          },
                          job_title_names: {
                              type: :array,
                              items: {
                                  type: :string
                              }
                          }
                      }
                  }
              }
          }
      )

      response '202', 'Campaigns updates are added to processing' do
        let!(:campaign_ids) { create_list(:campaign, 2, organization: user.organization).map(&:id) }
        let!(:job_title_names) do
          create_list(:job_title, 2, campaign_id: campaign_ids.first).map(&:name)
        end
        let(:body) do
          {
              job_titles_params: {
                  campaign_ids: campaign_ids,
                  job_title_names: job_title_names
              }
          }
        end

        examples(load_examples('application/json', 'v1/examples/campaigns/job_id_response'))

        run_test! do
          expect(
              ActiveJob::Base.queue_adapter.enqueued_jobs.select do |job|
                job[:job] == DefaultJob && job[:args].first == Campaigns::BulkJobTitlesUpdateService.name
              end.count
          ).to eq(1)

          expect(parsed_response['job_id']).not_to be_empty
        end
      end

      it_behaves_like 'Unauthorized request'
    end
  end
end

