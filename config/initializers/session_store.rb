# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_kurs_session', domain: {
    production:   '.k-kurs.ru',
    staging:      '.k-kurs.ru',
    development:   '.lvh.me' #'.k-kurs.ru'
    # development:  '.k-comment.ru'
}.fetch(Rails.env.to_sym, :all)
