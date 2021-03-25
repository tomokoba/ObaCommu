require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'ログインリンクが表示される: 左上から5番目のリンクが「ログイン」である' do
        log_in_link = find_all('a')[4].native.inner_text
        expect(log_in_link).to match(/ログイン/i)
      end
      it 'Log inリンクの内容が正しい' do
        log_in_link = find_all('a')[4].native.inner_text
        expect(page).to have_link log_in_link, href: new_user_session_path
      end
      it '会員登録リンクが表示される: 左上から3番目のリンクが「会員登録」である' do
        sign_up_link = find_all('a')[3].native.inner_text
        expect(sign_up_link).to match(/会員登録/i)
      end
      it '会員登録リンクの内容が正しい' do
        sign_up_link = find_all('a')[3].native.inner_text
        expect(page).to have_link sign_up_link, href: new_user_registration_path
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'タイトルが表示される' do
        expect(page).to have_content 'おばコミュ'
      end
      it 'トップページリンクが表示される: 左上から1番目のリンクが「トップページ」である' do
        top_link = find_all('a')[1].native.inner_text
        expect(top_link).to match(/トップページ/i)
      end
      it 'ゲストログインリンクが表示される: 左上から2番目のリンクが「ゲストログイン」である' do
        guest_login_link = find_all('a')[2].native.inner_text
        expect(guest_login_link).to match(/ゲストログイン/i)
      end
      it '会員登録リンクが表示される: 左上から3番目のリンクが「会員登録」である' do
        signup_link = find_all('a')[3].native.inner_text
        expect(signup_link).to match(/会員登録/i)
      end
      it 'ログインリンクが表示される: 左上から4番目のリンクが「ログイン」である' do
        login_link = find_all('a')[4].native.inner_text
        expect(login_link).to match(/ログイン/i)
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it 'トップページを押すと、トップ画面に遷移する' do
        top_link = find_all('a')[1].native.inner_text
        top_link = top_link.delete(' ')
        top_link.gsub!(/\n/, '')
        click_link top_link
        is_expected.to eq '/'
      end
      it 'ゲストログインを押すと、投稿一覧画面に遷移する' do
        guest_login_link = find_all('a')[2].native.inner_text
        guest_login_link = guest_login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link guest_login_link
        is_expected.to eq '/posts'
      end
      it '会員登録を押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[3].native.inner_text
        signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link signup_link
        is_expected.to eq '/users/sign_up'
      end
      it 'ログインを押すと、ログイン画面に遷移する' do
        login_link = find('#log-in').click.native.inner_text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link
        is_expected.to eq '/users/sign_in'
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「会員登録」と表示される' do
        expect(page).to have_content '会員登録'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '会員登録をするボタンが表示される' do
        expect(page).to have_button '会員登録をする'
      end
    end
  end

  describe 'ユーザログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it 'ログインと表示される' do
        expect(page).to have_content 'ログイン'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインするボタンが表示される' do
        expect(page).to have_button 'ログインする'
      end
      it 'nameフォームは表示されない' do
        expect(page).not_to have_field 'user[name]'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログインする'
      end

      it 'ログイン後のリダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/posts'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログインする'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログインする'
    end

    context 'ヘッダーの表示を確認' do
      it '投稿するリンクが表示される: 左上から1番目のリンクが「投稿する」である' do
        post_link = find_all('a')[1].native.inner_text
        expect(post_link).to match(/投稿する/i)
      end
      it 'マイページリンクが表示される: 左上から2番目のリンクが「マイページ」である' do
        mypage_link = find_all('a')[2].native.inner_text
        expect(mypage_link).to match(/マイページ/i)
      end
      it '会員一覧リンクが表示される: 左上から3番目のリンクが「会員一覧」である' do
        users_link = find_all('a')[3].native.inner_text
        expect(users_link).to match(/会員一覧/i)
      end
      it '投稿一覧リンクが表示される: 左上から4番目のリンクが「投稿一覧」である' do
        posts_link = find_all('a')[4].native.inner_text
        expect(posts_link).to match(/投稿一覧/i)
      end
      it 'お問い合わせリンクが表示される: 左上から5番目のリンクが「お問い合わせ」である' do
        contacts_link = find_all('a')[5].native.inner_text
        expect(contacts_link).to match(/お問い合わせ/i)
      end
      it 'ログアウトリンクが表示される: 左上から5番目のリンクが「ログアウト」である' do
        logout_link = find_all('a')[6].native.inner_text
        expect(logout_link).to match(/ログアウト/i)
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログインする'
      logout_link = find_all('a')[6].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(current_path).to eq '/'
      end
    end
  end
end
