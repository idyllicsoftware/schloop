require 'rails_helper'

RSpec.describe Admin::ActivitiesController, type: :controller do
  describe '#create' do
    login_product_admin
    before(:all) do
      @activity = {
        master_grade_id: '2', master_subject_id: '2',
        topic: 'test444', title: 'test444',
        categories: ['2'], teaches: '',
        pre_requisite: '', details: ''
      }
    end
    context 'valid input' do
      it 'has response status of 200' do
        post :create, activity: @activity
        expect(response.status).to eq 200
      end
      it 'has response status of 200' do
        post :create, activity: @activity
        expect(response.body).to include('errors', 'activity_id')
        expect(JSON.parse(response.body)['activity_id'] == Activity.last.id).to be_truthy
      end
    end
  end
end
