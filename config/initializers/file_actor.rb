# [Hyrax-overwrite] FileActor ingest_file method in Hyrax::Actors
# Perform characterize job only on preservation_master_file
Hyrax::Actors::FileActor.class_eval do
  # Persists file as part of file_set and spawns async job to characterize and create derivatives.
  # @param [JobIoWrapper] io the file to save in the repository, with mime_type and original_name
  # @return [CharacterizeJob, FalseClass] spawned job on success, false on failure
  # @note Instead of calling this method, use IngestJob to avoid synchronous execution cost
  # @see IngestJob
  # @todo create a job to monitor the temp directory (or in a multi-worker system, directories!) to prune old files that have made it into the repo
  def ingest_file(io)
    # Skip versioning because versions will be minted by VersionCommitter as necessary during save_characterize_and_record_committer.
    Hydra::Works::AddFileToFileSet.call(file_set,
                                        io,
                                        relation,
                                        versioning: false)
    return false unless file_set.save
    repository_file = related_file
    Hyrax::VersioningService.create(repository_file, user)
    pathhint = io.uploaded_file.uploader.path if io.uploaded_file # in case next worker is on same filesystem
    # Perform characterize job only on preservation_master_file
    CharacterizeJob.perform_later(file_set, repository_file.id, pathhint || io.path) if relation == :preservation_master_file
  end
end