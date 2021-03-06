# frozen_string_literal: true

# [Hyrax-overwrite]

json.files [@upload] do |uploaded_file|
  json.id uploaded_file.id
  # if uploaded_file.service_file.file.present?
  #   json.name uploaded_file.service_file.file.filename
  #   json.size uploaded_file.service_file.file.size
  # end
  # TODO: implement these
  # json.url  "/uploads/#{uploaded_file.id}"
  # json.thumbnail_url uploaded_file.id
  json.deleteUrl hyrax.uploaded_file_path(uploaded_file)
  json.deleteType 'DELETE'
end
