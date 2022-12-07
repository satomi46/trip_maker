require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '新規登録ができる場合' do
      it 'nickname, email, password, password_confirmationがあれば登録できる' do
        expect(@user).to be_valid
      end
    end

    context '新規登録できない場合' do
      it 'nicknameが空だとできない' do
        @user.nickname = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Nickname can't be blank")
      end

      it 'emailが空だとできない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end

      it 'emailに@がないとできない' do
        @user.email = 'aiueoaiueo'
        @user.valid?
        expect(@user.errors.full_messages).to include('Email is invalid')
      end

      it 'emailが既に登録されているとできない' do
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Email has already been taken')
      end

      it 'passwordが空だとできない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end

      it 'passwordが5文字以下だとできない' do
        @user.password = '123ab'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
      end

      it 'passwordが半角英数字混合でないとできない（英字のみ）' do
        @user.password = 'aiueoKA'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password should be half-width only, including both letters and numbers')
      end

      it 'passwordが半角英数字混合でないとできない（数字のみ）' do
        @user.password = '1234567'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password should be half-width only, including both letters and numbers')
      end

      it 'passwordに全角文字があるとできない' do
        @user.password = '134ERsagjgｇ'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password should be half-width only, including both letters and numbers')
      end

      it 'passwordとpassword_confirmationが一致しないとできない' do
        @user.password = '12345aiueo'
        @user.password_confirmation = 'aiueo12345'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
    end
  end
end
