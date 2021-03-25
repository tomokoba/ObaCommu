require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { user.valid? }

    let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    context 'nameカラム' do
      it '空欄でないこと' do
        user.name = ''
        is_expected.to eq false
      end
      it '2文字以上であること: 1文字は×' do
        user.name = Faker::Lorem.characters(number: 1)
        is_expected.to eq false
      end
      it '2文字以上であること: 2文字は〇' do
        user.name = Faker::Lorem.characters(number: 2)
        is_expected.to eq true
      end
      it '20文字以下であること: 20文字は〇' do
        user.name = Faker::Lorem.characters(number: 10)
        is_expected.to eq true
      end
      it '20文字以下であること: 21文字は×' do
        user.name = Faker::Lorem.characters(number: 11)
        is_expected.to eq false
      end
      it '一意性があること' do
        user.name = other_user.name
        is_expected.to eq false
      end
      context 'profileカラム' do
        it '1000文字以下であること: 1000文字は〇' do
          user.profile = Faker::Lorem.characters(number: 1000)
          is_expected.to eq true
        end
        it '1000文字以下であること: 1001文字は×' do
          user.profile = Faker::Lorem.characters(number: 1001)
          is_expected.to eq false
        end
      end
    end

    context '会員登録のテスト' do
      it "名前とメールアドレスとパスワードがあれば登録できる" do
        expect(FactoryBot.create(:user)).to be_valid
      end
      it "名前がなければ登録できない" do
        expect(FactoryBot.build(:user, name: "")).not_to be_valid
      end
      it "メールアドレスがなければ登録できない" do
        expect(FactoryBot.build(:user, email: "")).not_to be_valid
      end
      it "メールアドレスが重複していたら登録できない" do
        user1 = FactoryBot.create(:user, name: "kobata", email: "kobata@example.com")
        expect(FactoryBot.build(:user, name: "batako", email: user1.email)).not_to be_valid
      end
      it "パスワードがなければ登録できない" do
        expect(FactoryBot.build(:user, password: "")).not_to be_valid
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:posts).macro).to eq :has_many
      end
    end

    context 'Likeモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:likes).macro).to eq :has_many
      end
    end

    context 'LikedPostとの関係(ランキング)' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:liked_posts).macro).to eq :has_many
      end
    end

    context 'Commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:comments).macro).to eq :has_many
      end
    end

    context 'Relationshipモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:relationships).macro).to eq :has_many
      end
    end

    context 'Relationshipモデルとの関係(フォロー)' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:followings).macro).to eq :has_many
      end
    end

    context 'Relationshipモデルとの関係(フォロワー)' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:followers).macro).to eq :has_many
      end
    end

    context 'UserRoomモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:user_rooms).macro).to eq :has_many
      end
    end

    context 'Chatモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:chats).macro).to eq :has_many
      end
    end
  end
end
