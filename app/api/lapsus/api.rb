require 'pry'
module Lapsus
  class API < Grape::API
    version 'v1'
    format :json
    prefix :api

    resource :entries do
      post do
        params['entries'].each do |entry_attrs|
          Entry.create_with_project(entry_attrs)
        end
      end
    end
  end
end
