class CandidateRevision < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :revision
end
