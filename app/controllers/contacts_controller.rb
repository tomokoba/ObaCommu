class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  # お問い合わせ内容確認画面
  def confirm
    @contact = Contact.new(contact_params)
    if @contact.invalid?
      render :new
    end
  end

  # 入力内容変更
  def back
    @contact = Contact.new(contact_params)
    render :new
  end

  def error
    redirect_to new_contact_path
  end

  # 送信するアクション
  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.send_mail(@contact).deliver_now
      redirect_to posts_path, notice: "お問い合わせ内容を送信しました。"
    else
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :name, :message)
  end
end
