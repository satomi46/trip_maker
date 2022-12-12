require 'rails_helper'

RSpec.describe Detail, type: :model do
  before do
    @detail = FactoryBot.build(:detail)
  end

  describe '詳細スケジュール作成' do
    context '新規作成できる場合' do
      it 'title, importanceがあれば作成できる' do
        expect(@detail).to be_valid
      end
    end

    context '新規作成できない場合' do
      it 'titleが空だとできない' do
        @detail.title = ''
        @detail.valid?
        expect(@detail.errors.full_messages).to include("Title can't be blank")
      end

      it 'importanceが空だとできない' do
        @detail.importance = ''
        @detail.valid?
        expect(@detail.errors.full_messages).to include("Importance can't be blank")
      end
    end
  end
end
