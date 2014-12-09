require 'pry'
module Lapsus
  class API < Grape::API
    version 'v1'
    format :json
    prefix :api
    rescue_from :all

    resource :entries do
      post do
        Entry.create!(params['entries'])
        Trainer.train
      end
    end
  end
end
