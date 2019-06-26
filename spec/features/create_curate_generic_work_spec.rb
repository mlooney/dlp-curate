# frozen_string_literal: true
require 'rails_helper'
require_relative '../support/new_curate_generic_work_form.rb'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a CurateGenericWork' do
  context 'a logged in user' do
    let(:user_attributes) do
      { uid: 'test@example.com' }
    end
    let(:user) do
      User.new(user_attributes) { |u| u.save(validate: false) }
    end
    let(:admin_set_id) { AdminSet.find_or_create_default_admin_set_id }
    let(:permission_template) { Hyrax::PermissionTemplate.find_or_create_by!(source_id: admin_set_id) }
    let(:workflow) { Sipity::Workflow.create!(active: true, name: 'test-workflow', permission_template: permission_template) }

    before do
      # Create a single action that can be taken
      Sipity::WorkflowAction.create!(name: 'submit', workflow: workflow)

      # Grant the user access to deposit into the admin set.
      Hyrax::PermissionTemplateAccess.create!(
        permission_template_id: permission_template.id,
        agent_type: 'user',
        agent_id: user.user_key,
        access: 'deposit'
      )
      login_as user
    end

    let(:new_cgw_form) { NewCurateGenericWorkForm.new }
    let(:cgw) { FactoryBot.create(:work, user: user) }

    scenario "'descriptions' loads with all its inputs", js: true do
      new_cgw_form.visit_new_page

      expect(page).to have_css('#metadata input#curate_generic_work_title')
      expect(page).to have_css('#metadata select#curate_generic_work_rights_statement')

      click_link('Additional descriptive fields')
      expect(page).to have_content('Add another Note')

      expect(page).to have_css('#metadata input#curate_generic_work_staff_note')
      expect(page).to have_content('Add another Staff note')
    end

    scenario "repeating entries in the form", js: true do
      new_cgw_form.visit_new_page
      expect(page).to have_content('Creator')
      expect(page).to have_css('input#curate_generic_work_creator.multi_value')
      fill_in "curate_generic_work[creator][]", with: "first creator"
      click_on 'Add another Creator'
      expect(all("input[name='curate_generic_work[creator][]']").count).to eq(2)
      expect(page).not_to have_css('input#curate_generic_work_title.multi_value')
    end

    scenario "invalid etdf of Date Created", js: true do
      new_cgw_form.visit_new_page
      click_link('Additional descriptive fields')
      fill_in "curate_generic_work[date_created]", with: "invalid2"
      find('body').click
      expect(page).to have_css('.error-validate')
    end

    scenario "valid etdf of Date Created", js: true do
      new_cgw_form.visit_new_page
      click_link('Additional descriptive fields')
      fill_in "curate_generic_work[date_created]", with: "2012/2013"
      expect(page).not_to have_css('#curate_generic_work_date_issued-error')
    end

    scenario "metadata fields are validated", js: true do
      new_cgw_form.visit_new_page.metadata_fill_in_with
      find('body').click
      expect(page).to have_css('li#required-metadata.complete')
    end

    scenario "url fields are validated" do
      new_cgw_form.visit_new_page.metadata_fill_in_with.attach_files.check_visibility

      click_link('Additional descriptive fields')
      fill_in "curate_generic_work[final_published_version][]", with: "teststring"

      click_on('Save')

      expect(page).to have_content("is not a valid URL")
    end

    scenario "custom terms show up as dynamic option for external vocab fields", js: true do
      new_cgw_form.visit_new_page

      click_link('Additional descriptive fields')
      fill_in "curate_generic_work[institution]", with: "Test3"
      expect(find('div.ui-menu-item-wrapper', match: :first).text).to eq 'Test3'
    end

    scenario "verify work visibility can be edited" do
      expect(cgw.visibility).to eq 'restricted'

      visit("/concern/curate_generic_works/#{cgw.id}/edit")

      find('body').click
      choose('curate_generic_work_visibility_open')
      click_on('Save')

      cgw.reload
      expect(cgw.visibility).to eq 'open'
    end

    scenario "Create Curate Work" do
      visit '/concern/curate_generic_works/new'

      # If you generate more than one work uncomment these lines
      # choose "payload_concern", option: "CurateGenericWork"
      # click_button "Create work"

      expect(page).to have_content "Add New Curate Generic Work"
      expect(page).to have_css('input#curate_generic_work_title.required')
      click_link "Files" # switch tab
      expect(page).to have_content "Add files"
      # expect(page).to have_content "Add folder"
      # within('span#addfiles') do
      #   attach_file("files[]", "#{Hyrax::Engine.root}/spec/fixtures/image.jp2", visible: false)
      #   attach_file("files[]", "#{Hyrax::Engine.root}/spec/fixtures/jp2_fits.xml", visible: false)
      # end
      click_link "Descriptions" # switch tab
      # fill_in('Title', with: 'My Test Work')
      # fill_in('Creator', with: 'Doe, Jane')
      # fill_in('Keyword', with: 'testing')
      # select('In Copyright', from: 'Rights statement')

      # With selenium and the chrome driver, focus remains on the
      # select box. Click outside the box so the next line can't find
      # its element
      find('body').click
      choose('curate_generic_work_visibility_open')
      expect(page).to have_content('Please note, making something visible to the world (i.e. marking this as Public) may be viewed as publishing which could impact your ability to')
      check('agreement')

      # click_on('Save')
      # expect(page).to have_content('My Test Work')
      # expect(page).to have_content "Your files are being processed by Hyrax in the background."
    end
  end

  # context 'QA is appropriately loaded' do
  #   it "returns search result for LOC names subauthority" do
  #     subauthority = Qa::Authorities::Loc.subauthority_for('names')
  #     search_result = subauthority.search('Emory')

  #     expected_result = [{ "id" => "info:lc/authorities/names/no97052934", "label" => "Emory University Museum bulletin" },
  #                        { "id" => "info:lc/authorities/names/n93031439", "label" =>
  #                          "Appalachian Oral History Project of Alice Lloyd College, Appalachian State University, Emory and Henry College, and Lees Junior College" },
  #                        { "id" => "info:lc/authorities/names/n80017622", "label" => "Emory University. Department of Psychiatry" },
  #                        { "id" => "info:lc/authorities/names/no2012033126", "label" => "Emory University. Alumni Association" },
  #                        { "id" => "info:lc/authorities/names/no2006021658", "label" => "Emory Center for Myth and Ritual in American Life" },
  #                        { "id" => "info:lc/authorities/names/n94084139", "label" => "Emory Center for the Arts" }, { "id" => "info:lc/authorities/names/n84736378", "label" => "Emory Vico studies" }
  #                        , { "id" => "info:lc/authorities/names/no2005102736", "label" => "Emory Institute for Women's Studies" }, { "id" => "info:lc/authorities/names/no2001070729", "label" =>
  #                          "Emory University. Law and Religion Program" }, { "id" => "info:lc/authorities/names/n84176318", "label" => "Emory University. Department of Medicine" },
  #                        { "id" => "info:lc/authorities/names/no2012033509", "label" => "Emory University. Department of Geology" }, { "id" => "info:lc/authorities/names/n88500030", "label" =>
  #                          "Emory studies in humanities" },
  #                        { "id" => "info:lc/authorities/names/no2011188020", "label" => "Emory University. President's Office" }, { "id" => "info:lc/authorities/names/n83030612", "label" =>
  #                          "Emory and Henry College" },
  #                        { "id" => "info:lc/authorities/names/n93053981", "label" => "Emory texts and studies in ecclesial life" }, { "id" => "info:lc/authorities/names/no2012103342", "label" =>
  #                          "Caucus of Emory Black Alumni" }, { "id" => "info:lc/authorities/names/no2005090287", "label" => "Emory University. College of Arts and Sciences" },
  #                        { "id" => "info:lc/authorities/names/no2005102739", "label" => "Emory Women's Center" }, { "id" => "info:lc/authorities/names/no2012110949", "label" =>
  #                          "D. V. S. Senior Honor Society (Emory University)" },
  #                        { "id" => "info:lc/authorities/names/n83165634", "label" => "Emory University. Department of Gynecology-Obstetrics" }]

  #     expect(search_result).to eq(expected_result)
  #   end
  # end
end
