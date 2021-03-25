require 'rails_helper'
require "refile/file_double"

RSpec.describe 'Postモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { post.valid? }

    let(:user) { create(:user) }
    let!(:post) { build(:post, user_id: user.id) }

    context 'titleカラム' do
      it '空欄でないこと' do
        post.title = ''
        is_expected.to eq false
      end
    end

    context 'captionカラム' do
      it '空欄でないこと' do
        post.caption = ''
        is_expected.to eq false
      end
      it '1000文字以下であること: 1000文字は〇' do
        post.caption = Faker::Lorem.characters(number: 1000)
        is_expected.to eq true
      end
      it '1000文字以下であること: 1001文字は×' do
        post.caption = Faker::Lorem.characters(number: 1001)
        is_expected.to eq false
        expect(post.errors.messages[:caption]).to include("は1000文字以内で入力してください")
      end
    end

    context 'photos_imagesカラム' do
      it '5枚以下であること: 5枚は〇' do
        4.times do
          post.photos << FactoryBot.build(:photo)
        end
        is_expected.to eq true
      end
      it '5枚以下であること: 6枚は×' do
        5.times do
          post.photos << FactoryBot.build(:photo)
        end
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
  end
end
