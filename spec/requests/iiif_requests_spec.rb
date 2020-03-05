
# frozen_string_literal: true
require "rails_helper"
include Warden::Test::Helpers

RSpec.describe "IIIF requests", :clean, type: :request do
  let(:public_work_id) { "658pc866ww-cor" }
  let(:work_id) { "436tx95xcc-cor" }
  let(:public_image_sha) { "465c0075481fe4badc58c76fba42161454a18d1f" }
  let(:image_sha) { "79276774f3dbfbd977d39065eec14aa185b5213d" }
  let(:region) { "full" }
  let(:size) { "full" }
  let(:rotation) { 0 }
  let(:quality) { "default" }
  let(:format) { "jpg" }
  # let(:params) do
  #   {
  #     identifier: image_sha,
  #     region:     region,
  #     size:       size,
  #     rotation:   rotation,
  #     quality:    quality,
  #     format:     format
  #   }
  # end

  before do
    ENV['IIIF_MANIFEST_CACHE'] = Rails.root.join('tmp').to_s
    ENV['PROXIED_IIIF_SERVER_URL'] = 'https://iiif-cor-arch.library.emory.edu/cantaloupe/iiif/2'
    ENV['LUX_BASE_URL'] = "https://digital-arch.library.emory.edu"
    WebMock.allow_net_connect!
  end
  describe "GET image" do
    context "with a public object" do
      let(:attributes) do
        { "id" => public_work_id,
          "digest_ssim" => ["urn:sha1:#{public_image_sha}"],
          "visibility_ssi" => "open" }
      end
      before do
        solr = Blacklight.default_index.connection
        solr.add([attributes])
        solr.commit
      end
      it "responds with a success status" do
        get "/iiif/2/#{public_image_sha}/#{region}/#{size}/#{rotation}/#{quality}.#{format}"
        expect(response.status).to eq 200
        expect(response.has_header?("Access-Control-Allow-Origin")).to be_truthy
        expect(response.get_header("Access-Control-Allow-Origin")).to eq "*"
      end
    end
    context "with an Emory High Download object" do
      let(:attributes) do
        { "id" => work_id,
          "digest_ssim" => ["urn:sha1:#{image_sha}"],
          "visibility_ssi" => "authenticated" }
      end
      before do
        solr = Blacklight.default_index.connection
        solr.add([attributes])
        solr.commit
        get "/iiif/2/#{image_sha}/#{region}/#{size}/#{rotation}/#{quality}.#{format}"
      end
      it "responds with a success status" do
        expect(response.status).to eq 200
      end
      it "has access control header limited to curate" do
        expect(response.has_header?("Access-Control-Allow-Origin")).to be_truthy
        expect(response.get_header("Access-Control-Allow-Origin")).to eq "https://digital-arch.library.emory.edu"
      end
    end
  end
  # describe "GET manifest" do
  #   context "with a public object" do
  #     it "responds with a success status" do
  #       get "/iiif/"
  #     end
  #   end
  # end
end
