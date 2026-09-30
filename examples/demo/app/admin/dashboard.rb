ActiveAdmin.register_page 'Dashboard' do
  content do
    h2 'Settings demo'
    para 'Manage the same settings here or in RailsAdmin.'
    para link_to('Open settings', admin_rails_admin_settings_settings_path)
  end
end
