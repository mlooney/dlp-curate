# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CurateMapper do
  subject(:mapper) { described_class.new }

  let(:metadata) do
    {
      "abstract" => "Verso: Advertisting, High Boy Cigarettes. Photo by: Teenie Harris, staff (black) photographer for Pittsburg Courier",
      "administrative_unit" => "Stuart A. Rose Manuscript, Archives and Rare Book Library",
      "conference_name" => "Exposition universelle de 1878 (Paris, France)",
      "content_genres" => "black-and-white photographs|photographic negatives",
      "contact_information" => "Stuart A. Rose Manuscript, Archives and Rare Book Library rose.library@emory.edu",
      "content_type" => 'still image',
      "contributors" => "Craigie, Dorothy, 1901- collector. GEU|Greene, Graham, 1904-1991, collector. GEU",
      "copyright_date" => "1985-11-01",
      "creator" => "Harris, Teenie, 1908-1998.",
      "data_classifications" => "Confidential|Internal",
      "date_created" => "1985-11-01",
      "date_issued" => "Unknown",
      "edition" => "2nd edition.",
      "holding_repository" => "Stuart A. Rose Manuscript, Archives and Rare Book Library",
      "institution" => "Emory University",
      "internal_rights_note" => "This is my internal rights note.",
      "keywords" => "Tangerine|Blueberry",
      "emory_ark" => "ark://abc/123",
      "other_identifiers" => "dams:152815|MSS1218_B001_I002",
      "local_call_number" => "MSS 1218",
      "notes" => "This is a note.",
      "pcdm_use" => nil,
      "place_of_production" => "London",
      "primary_language" => "English",
      "publisher" => "Gutenberg",
      "rights_holders" => "Unknown",
      "rights_statement" => "http://rightsstatements.org/vocab/InC/1.0/",
      "emory_rights_statements" => "Emory University does not control copyright for this image.",
      "series_title" => "Chatterbox library.",
      "subject_geo" => "Ghana.|Africa.",
      "subject_names" => "Mouvement national congolais.|Okito, Joseph.|Lumumba, Patrice, 1925-1961.",
      "subject_topics" => "Snowblowers.|Snow.|Air bases.|Towers.",
      "system_of_record_ID" => "990020982660302486",
      "table_of_contents" => "Thing 1. Thing 2.",
      "title" => "what an awesome title",
      "uniform_title" => "Pittsburg courier.",
      "visibility" => "Emory Network"
    }
  end

  before { mapper.metadata = metadata }

  it 'is configured to be the zizia metadata mapper' do
    expect(Zizia.config.metadata_mapper_class).to eq described_class
  end

  context "#abstract" do
    it "maps the abstract field" do
      expect(mapper.abstract).to eq "Verso: Advertisting, High Boy Cigarettes. Photo by: Teenie Harris, staff (black) photographer for Pittsburg Courier"
    end
  end

  context "#administrative_unit" do
    it "does its best to match the configured controlled vocabulary term" do
      expect(mapper.administrative_unit).to eq "Stuart A. Rose Manuscript, Archives, and Rare Book Library"
    end
  end

  context "#conference_name" do
    it "maps the conference_NAME field" do
      expect(mapper.conference_name).to eq "Exposition universelle de 1878 (Paris, France)"
    end
  end

  context "#content_genres" do
    it "maps the content_genres field" do
      expect(mapper.content_genres).to eq ["black-and-white photographs", "photographic negatives"]
    end
  end

  context "#contact_information" do
    it "maps the contact_information field" do
      expect(mapper.contact_information).to eq "Stuart A. Rose Manuscript, Archives and Rare Book Library rose.library@emory.edu"
    end
  end

  context "#content_type" do
    context "when the string matches exactly" do
      let(:metadata) do
        {
          "title" => "my title",
          "content_type" => 'Still image'
        }
      end
      it "maps content_type to a uri" do
        expect(mapper.content_type).to eq "http://id.loc.gov/vocabulary/resourceTypes/img"
      end
    end
    context "when the string matches except for capitalization and whitespace" do
      let(:metadata) do
        {
          "title" => "my title",
          "content_type" => 'still image  '
        }
      end
      it "maps content_type to a uri" do
        expect(mapper.content_type).to eq "http://id.loc.gov/vocabulary/resourceTypes/img"
      end
    end
    context "when the CSV has a uri instead of a string" do
      let(:metadata) do
        {
          "title" => "my title",
          "content_type" => 'http://id.loc.gov/vocabulary/resourceTypes/img'
        }
      end
      it "maps content_type to the uri" do
        expect(mapper.content_type).to eq "http://id.loc.gov/vocabulary/resourceTypes/img"
      end
    end
  end

  context "#contributors" do
    it "maps the contributors field" do
      expect(mapper.contributors).to contain_exactly("Craigie, Dorothy, 1901- collector. GEU", "Greene, Graham, 1904-1991, collector. GEU")
    end
  end

  context "#copyright_date" do
    it "maps the copyright_date field" do
      expect(mapper.copyright_date).to eq "1985-11-01"
    end
  end

  context "#creator" do
    it "maps the creator field" do
      expect(mapper.creator).to eq ["Harris, Teenie, 1908-1998."]
    end
  end

  context "#data_classifications" do
    it "maps the data_classifications field" do
      expect(mapper.data_classifications).to contain_exactly("Confidential", "Internal")
    end
  end

  context "#date_created" do
    it "maps the date_created field" do
      expect(mapper.date_created).to eq "1985-11-01"
    end
  end

  context "#date_digitized" do
    let(:metadata) do
      {
        "title" => "my title",
        "date_digitized" => "1985-11-01"
      }
    end
    it "maps the date_digitized field" do
      expect(mapper.date_digitized).to eq "1985-11-01"
    end
  end

  context "#date_issued" do
    it "maps the date_issued field" do
      expect(mapper.date_issued).to eq "Unknown"
    end
  end

  context "#edition" do
    it "maps the edition field" do
      expect(mapper.edition).to eq "2nd edition."
    end
  end

  context "#extent" do
    let(:metadata) do
      {
        "title" => "my title",
        "extent" => "10.29 x 08.53 inches"
      }
    end
    it "maps the extent field" do
      expect(mapper.extent).to eq "10.29 x 08.53 inches"
    end
  end

  context "#holding_repository" do
    it "maps the holding_repository field" do
      expect(mapper.holding_repository).to eq "Stuart A. Rose Manuscript, Archives and Rare Book Library"
    end
  end

  context "#institution" do
    it "maps the institution field" do
      expect(mapper.institution).to eq "Emory University"
    end
  end

  context "#internal_rights_note" do
    it "maps the internal_rights_note field" do
      expect(mapper.internal_rights_note).to eq "This is my internal rights note."
    end
  end

  context "#keywords" do
    it "maps the keywords field" do
      expect(mapper.keywords).to contain_exactly("Tangerine", "Blueberry")
    end
  end

  context "#emory_ark" do
    it "maps the emory_ark field" do
      expect(mapper.emory_ark).to contain_exactly("ark://abc/123")
    end
  end

  context "#other_identifiers" do
    it "maps the other_identifiers field" do
      expect(mapper.other_identifiers).to contain_exactly("dams:152815", "MSS1218_B001_I002")
    end
  end

  context "#legacy_rights" do
    let(:legacy_rights) do
      "Emory University does not control copyright for this image.  This image is made available for individual viewing and reference for educational purposes only such as personal study, preparation for teaching, and research.  Your reproduction, distribution, public display or other re-use of any content beyond a fair use as codified in section 107 of US Copyright Law is at your own risk.  We are always interested in learning more about our collections.  If you have information regarding this photograph, please contact marbl@emory.edu."
    end
    let(:metadata) do
      {
        "title" => "my title",
        "legacy_rights" => legacy_rights
      }
    end
    it "maps the legacy_rights field" do
      expect(mapper.legacy_rights).to eq legacy_rights
    end
  end

  context "#local_call_number" do
    it "maps the local_call_number field" do
      expect(mapper.local_call_number).to eq "MSS 1218"
    end
  end

  context "#place_of_production" do
    it "maps the place_of_production field" do
      expect(mapper.place_of_production).to eq "London"
    end
  end

  context "#notes" do
    it "maps the notes field" do
      expect(mapper.notes).to eq ["This is a note."]
    end
  end

  context "#pcdm_use" do
    context "primary content" do
      let(:metadata) do
        {
          "pcdm_use" => "Primary Content"
        }
      end
      it "maps pcdm_use to FileSet:PRIMARY" do
        expect(mapper.pcdm_use).to eq(FileSet::PRIMARY)
      end
    end
    context "supplemental" do
      let(:metadata) do
        {
          "pcdm_use" => "supplemental Content"
        }
      end
      it "maps pcdm_use to FileSet::SUPPLEMENTAL" do
        expect(mapper.pcdm_use).to eq(FileSet::SUPPLEMENTAL)
      end
    end
    context "supplemental preservation" do
      let(:metadata) do
        {
          "pcdm_use" => "Supplemental preservation"
        }
      end
      it "maps pcdm_use to FileSet::PRESERVATION" do
        expect(mapper.pcdm_use).to eq(FileSet::PRESERVATION)
      end
    end

    context "nil" do
      it "maps pcdm_use to primary content" do
        expect(mapper.pcdm_use).to eq(FileSet::PRIMARY)
      end
    end

    context "empty string" do
      let(:metadata) do
        {
          "pcdm_use" => ""
        }
      end
      it "maps pcdm_use to primary content" do
        expect(mapper.pcdm_use).to eq(FileSet::PRIMARY)
      end
    end
  end

  context "#primary_language" do
    it "maps the primary_language field" do
      expect(mapper.primary_language).to eq "English"
    end
  end

  context "#publisher" do
    it "maps the publisher field" do
      expect(mapper.publisher).to eq "Gutenberg"
    end
  end

  context "#rights_holders" do
    it "maps the rights_holders field" do
      expect(mapper.rights_holders).to eq ["Unknown"]
    end
  end

  context "#emory_rights_statements" do
    it "maps the emory_rights_statements field" do
      expect(mapper.emory_rights_statements)
        .to contain_exactly("Emory University does not control copyright for this image.")
    end
  end

  context "#rights_statement" do
    it "maps the rights_statement field when it's valid" do
      expect(mapper.rights_statement).to eq ["http://rightsstatements.org/vocab/InC/1.0/"]
    end
    context "invalid rights statement" do
      let(:metadata) do
        {
          "rights_statement" => "http://badrightsstatements.org/vocab/InC/1.0/"
        }
      end
      it "raises an exception when it isn't valid" do
        expect { mapper.rights_statement }.to raise_error RuntimeError
      end
    end
  end

  context "#sensitive_material" do
    let(:metadata) do
      {
        "title" => "my title",
        "sensitive_material" => "No"
      }
    end
    it "maps the sensitive_material field to what the QA authority expects" do
      expect(mapper.sensitive_material).to eq "false"
    end
  end

  context "#sensitive_material_note" do
    let(:metadata) do
      {
        "title" => "my title",
        "sensitive_material_note" => "Be very careful with this sensitive material."
      }
    end
    it "maps the sensitive_material_note field" do
      expect(mapper.sensitive_material_note).to eq "Be very careful with this sensitive material."
    end
  end

  context "#series_title" do
    it "maps the series_title field" do
      expect(mapper.series_title).to eq "Chatterbox library."
    end
  end

  context "#subject_geo" do
    it "maps the subject_geo field" do
      expect(mapper.subject_geo)
        .to contain_exactly("Ghana.", "Africa.")
    end
  end

  context "#subject_names" do
    it "maps the subject_names field" do
      expect(mapper.subject_names)
        .to contain_exactly("Mouvement national congolais.", "Okito, Joseph.", "Lumumba, Patrice, 1925-1961.")
    end
  end

  context "#subject_topics" do
    it "maps the subject_topics field" do
      expect(mapper.subject_topics)
        .to contain_exactly("Snowblowers.", "Snow.", "Air bases.", "Towers.")
    end
  end

  context "#sublocation" do
    let(:metadata) do
      {
        "title" => "my title",
        "sublocation" => "Box 1"
      }
    end
    it "maps the sublocation field" do
      expect(mapper.sublocation).to eq "Box 1"
    end
  end

  context "#system_of_record_ID" do
    it "maps the system_of_record_ID field" do
      expect(mapper.system_of_record_ID).to eq "990020982660302486"
    end
  end

  context "#table_of_contents" do
    it "maps the table_of_contents field" do
      expect(mapper.table_of_contents)
        .to eq "Thing 1. Thing 2."
    end
  end

  context "#title" do
    it "maps the required title field" do
      expect(mapper.map_field(:title))
        .to contain_exactly("what an awesome title")
    end
  end

  context "#transfer_engineer" do
    let(:metadata) do
      {
        "title" => "my title",
        "transfer_engineer" => "Leroy Jenkins"
      }
    end
    it "maps the transfer_engineer field" do
      expect(mapper.transfer_engineer).to eq "Leroy Jenkins"
    end
  end

  context "#uniform_title" do
    it "maps the uniform_title field" do
      expect(mapper.uniform_title)
        .to eq "Pittsburg courier."
    end
  end

  context "#visibility" do
    context "Emory Network" do
      let(:metadata) do
        {
          "title" => "my title",
          "content_type" => "http://id.loc.gov/vocabulary/resourceTypes/img",
          "visibility" => "Emory Network"
        }
      end
      it "gives authenticated" do
        expect(mapper.visibility).to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
      end
    end
  end

  describe '#fields' do
    it 'has expected fields' do
      expect(mapper.fields).to include(
        :title,
        :visibility
      )
    end
  end
end
