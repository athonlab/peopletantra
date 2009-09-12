require 'csv'
ENV["RAILS_ENV"] = "development"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
all_candidates_file = 'csvs/all_candidates_info.csv'

@header = []
def row_to_hash row
  tuples = @header.zip(row)
  hash = {}
  tuples.each do |tuple|
    hash[tuple.first] = tuple.last
  end
  return hash
end

@states = {}
def update_state row_hash
  if @states.has_key?(row_hash['STATE'])
    state = @states[row_hash['STATE']]    
  else
    state = State.create(:name => row_hash['STATE'], :code => row_hash['STATE CODE'])
    @states[state.name] = state
  end
  return state
end 

@constituencies = {}
def update_constituency row_hash, state
  if @constituencies.has_key?(row_hash['PARLIAMENTARY CONSTITUENCY'])
    constituency = @constituencies[row_hash['PARLIAMENTARY CONSTITUENCY']]
  else
    constituency = Constituency.create(:name => row_hash['PARLIAMENTARY CONSTITUENCY'], :code => row_hash['PC NO'], :state => state)
    @constituencies[constituency.name] = constituency
  end
  return constituency
end

@parties = {}
def update_party row_hash
  if @parties.has_key?(row_hash['Party'])
    party = @parties[row_hash['Party']]
  else
    party = Party.create :code => row_hash['Party'], :symbol => row_hash['SYMBOL_NO']
    @parties[party.code] = party
  end
  return party
end 

def update_candidate row_hash, constituency, party
  candidate = Candidate.create :name => row_hash['CAND NAME'], :sex => row_hash['SEX'], :address_line_1 =>  row_hash['CAND ADDR LINE 1'], :address_line_2 => row_hash["CAND ADDR LINE 2"], :city_town_village => row_hash["CITY TOWN/VILL."], :age => row_hash['AGE'], :category => row_hash["CAND CATEGORY"], :constituency => constituency, :party => party
  return candidate
end

def associate_candidate_with_election row_hash, candidate, election
  candidate_revision = ElectionCandidate.create :candidate => candidate, :election => election, :evm_votes => row_hash['EVM Votes'], :postal_votes => row_hash['PostalVotes'], :total_votes => row_hash['TotalVotes']
  return candidate_revision
end
Revision.create :number => '15', :house => 'loksabha'
Revision.create :number => '15', :house => 'rajyasabha'
Election.create :name => '2009'
@election = Election.default

CSV::Reader.parse(File.open(all_candidates_file, 'rb')) do |row|
  if @header.empty?
    @header = row
  else
    row_hash = row_to_hash(row)
    state = update_state(row_hash)
    constituency = update_constituency(row_hash, state)
    party = update_party(row_hash) 
    candidate = update_candidate(row_hash, constituency, party)
    candidate_revision = associate_candidate_with_election(row_hash, candidate, @election)
  end
end



