require 'rails_helper'

RSpec.describe Relationship, type: :model do

  before do
    @user = FactoryBot.create(:user)
    @another_user = FactoryBot.create(:user)
    # Userモデルに定義したfollowメソッド（active_relationships.create）の実行結果を代入
    @relationship = @user.follow(@another_user)
  end
  
  describe '新規リレーション作成（フレンド申請）' do
    context '作成できる場合' do
      it 'follower_id, followed_idがあれば作成できる' do
        expect(@relationship).to be_valid
      end
    end

    context '作成できない場合' do
      it 'follower_idが空だとできない' do
        @relationship.follower_id = ''
        @relationship.valid?
        expect(@relationship.errors.full_messages).to include("Follower can't be blank")
      end
      
      it 'followed_idが空だとできない' do
        @relationship.followed_id = ''
        @relationship.valid?
        expect(@relationship.errors.full_messages).to include("Followed can't be blank")
      end
      
      it 'relationが既に登録されているとできない' do
        @relationship.save
        another_relationship = @user.follow(@another_user)
        another_relationship.valid?
        expect(another_relationship.errors.full_messages).to include('Follower has already been taken')
      end
    end
  end
end
