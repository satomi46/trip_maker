require 'rails_helper'

RSpec.describe Trip, type: :model do
  before do
    @trip = FactoryBot.build(:trip)
  end

  describe '旅行計画作成' do
    context '新規作成できる場合' do
      it 'image, title, start_date, end_dateがあれば作成できる' do
        expect(@trip).to be_valid
      end
    end

    context '新規作成できない場合' do
      it 'imageが添付されていなければできない' do
        @trip.image = nil
        @trip.valid?
        expect(@trip.errors.full_messages).to include("Image can't be blank")
      end

      it 'titleが空だとできない' do
        @trip.title = ''
        @trip.valid?
        expect(@trip.errors.full_messages).to include("Title can't be blank")
      end

      it 'start_dateが空だとできない' do
        @trip.start_date = ''
        @trip.valid?
        expect(@trip.errors.full_messages).to include("Start date can't be blank")
      end

      it 'end_dateが空だとできない' do
        @trip.end_date = ''
        @trip.valid?
        expect(@trip.errors.full_messages).to include("End date can't be blank")
      end

      it 'end_dateがstart_dateより前の日付だとできない' do
        @trip.end_date = @trip.start_date - 1
        @trip.valid?
        expect(@trip.errors.full_messages).to include('End date must be same or later than Start date')
      end
    end
  end
end
