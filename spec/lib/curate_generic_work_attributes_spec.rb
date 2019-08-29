# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CurateGenericWorkAttributes do
  let(:work_attributes) { described_class.instance }
  it 'has a list of attributes' do
    expect(work_attributes.attributes).to match_array(['access_control_id', 'representative_id', 'thumbnail_id', 'rendering_ids', 'admin_set_id', 'embargo_id', 'lease_id', 'head', 'tail', 'depositor', 'title', 'date_uploaded', 'date_modified', 'state', 'proxy_depositor', 'on_behalf_of', 'arkivo_checksum', 'owner', 'institution', 'holding_repository', 'administrative_unit', 'sublocation', 'content_type', 'content_genre', 'abstract', 'table_of_contents', 'edition', 'primary_language', 'subject_topics', 'subject_names', 'subject_geo', 'subject_time_periods', 'conference_name', 'uniform_title', 'series_title', 'parent_title', 'contact_information', 'publisher_version', 'creator', 'contributor', 'sponsor', 'data_producer', 'grant', 'grant_information', 'author_notes', 'note', 'data_source_note', 'geographic_unit', 'technical_note', 'issn', 'isbn', 'related_publications', 'related_datasets', 'extent', 'date_issued', 'conference_dates', 'data_collection_dates', 'local_call_number', 'related_material', 'final_published_version', 'issue', 'page_range_start', 'page_range_end', 'volume', 'place_of_production', 'keywords', 'rights_statement_text', 'rights_statement', 'rights_holder', 'copyright_date', 'access_right', 'rights_documentation', 'scheduled_rights_review', 'scheduled_rights_review_note', 'internal_rights_note', 'legacy_rights', 'data_classification', 'sensitive_material', 'sensitive_material_note', 'staff_note', 'date_digitized', 'transfer_engineer', 'legacy_identifier', 'legacy_ark', 'system_of_record_ID', 'primary_repository_ID', 're_use_license', 'publisher', 'date_created', 'preservation_workflow']) # rubocop:disable Metrics/LineLength
  end
end
