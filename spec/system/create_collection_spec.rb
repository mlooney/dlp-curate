# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Creating a collection', :perform_jobs, clean: true, admin_set: true, type: :system, js: true do
  context 'logged in as an admin user' do
    let(:admin_user) { FactoryBot.create(:admin) }

    before do
      login_as admin_user
    end

    it 'sucessfully creates a collection with the UI' do
      visit 'dashboard/collections/new'
      expect(page).to have_content 'New User Collection'
      fill_in 'title (Title)', with: 'testing title'
      fill_in 'holding_repository (Library)', with: 'testing library'
      fill_in 'creator (Creator)', with: 'creator'
      fill_in 'abstract (Description/Abstract)', with: 'test'
      click_link('Additional fields')
      fill_in 'Finding aid link', with: 'https://example.org/collection'
      click_on 'Save'
      expect(page).to have_content 'Collection was successfully created'
    end

    it "has expected input fields" do
      visit("dashboard/collections/new?collection_type_id=1")
      expect(page).to have_css("textarea#collection_title")
      click_link('Additional fields')
      expect(page).to have_css("input#collection_creator")
      expect(page).to have_content("Add another creator (Creator)")
    end

    it "validates url fields" do
      visit 'dashboard/collections/new'
      expect(page).to have_content 'New User Collection'
      fill_in 'title (Title)', with: 'testing title'
      fill_in 'holding_repository (Library)', with: 'testing library'
      fill_in 'creator (Creator)', with: 'creator'
      fill_in 'abstract (Description/Abstract)', with: 'test'
      click_link('Additional fields')
      fill_in 'Finding aid link', with: 'teststring'
      click_on 'Save'
      click_link('Additional fields')
      expect(page).to have_content("is not a valid URL")
    end
  end
end
