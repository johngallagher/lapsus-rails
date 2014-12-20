require 'spec_helper'

describe Users::RegistrationsController, type: :controller do
  describe 'creating a user' do
    include Devise::TestHelpers
    
    it 'creates an associated preset project for none' do
      request.env["devise.mapping"] = Devise.mappings[:user]
      
      post :create, { user: { email: 'dummy@example.com', password: 'password', password_confirmation: 'password' }}

      none = Project.none_for_user(User.first)
      expect(User.count).to eq(1)
      expect(none).to be_present
      expect(none.name).to eq('None')
      expect(none.path).to eq('')
    end
  end

end
