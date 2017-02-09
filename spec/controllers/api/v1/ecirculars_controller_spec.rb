require 'rails_helper'

RSpec.describe Api::V1::EcircularsController, type: :controller do
  it 'should not raise execption of method not found' do
    expect {get :circular_teachers}.not_to  raise_error
  end
end
