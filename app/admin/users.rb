ActiveAdmin.register User do
  index do
    column :username
    column :email
    column :last_sign_in_at
    column :last_sign_in_ip
    default_actions
  end
end
