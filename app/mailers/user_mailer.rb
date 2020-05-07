class UserMailer < ApplicationMailer

  default from: 'info@k-comment.ru'

    def test_welcome_email(user_email)
      # @user = User.first#params[:user]
      # @url  = 'http://example.com/login'
      @user_email = user_email
      # mail(to: @user.email, subject: 'Welcome to My Awesome Site')
      mail(to: "panaet80@gmail.com, info@two-g.ru",
          reply_to: @user_email ,
          subject: 'Новая регистрация в приложении K-Kurs')
    end

    def service_end_email(user_email)
      @user_email = user_email
      @url  = 'https://k-comment.ru/users/sign_in'
      mail(to: @user_email, subject: 'Заканчивается срок оплаты сервиса')
    end

end
