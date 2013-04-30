require 'spec_helper'

# When I am a store admin and I am viewing my store dashboard, I can create a refund (an order with a negative total)

describe "when I am a store admin and I am viewing my store dashboard" do
  let!(:store_admin) { User.create!(full_name: "Mr. Admin",
                                    email: "admin@example.com",
                                    password: "password",
                                    platform_administrator: true) }

  let!(:store) { Store.create!(name: "Test",
                               slug: "test",
                               status: "enabled") }

  let!(:admin_role) { Role.create!(title: "admin") }

  let!(:user_store) { UserStore.create!(user_id:  store_admin.id,
                                        store_id: store.id,
                                        role_id:  admin_role.id) }

  before do
    visit login_path
    fill_in("email", with: store_admin.email)
    fill_in("password", with: "password")
    click_button("Log in")
    visit profile_path
    click_link("Manage")
  end

  it "shows a 'Refund' button" do
    expect(page).to have_content("Refund")
  end

  it "creates a refund order" do
  end
end