class Stancer::Stance
  require 'json'

  def initialize(i, group, filter=nil)
    # options?
    @indicators = i['indicators']
    # Quick hack. TODO Make this better.
    @groups = [group, "#{group.to_s}_id"]
    @filter = filter
  end

  def to_h
    Hash[ scored_votes.map { |bloc, as| [ bloc, Stancer::Score.new(as).to_h ] } ]
  end

  private 

  def scored_votes
    @__scored_votes ||= score_votes!
  end

  def _weighted_votes(vote_list, weight_hash)
    vote_list.map do |v|
      {
        option: v['option'],
        score: weight_hash[v['option']],
        min: weight_hash.values.min,
        max: weight_hash.values.max,
      }
    end
  end

  def score_votes!
    scored_votes = {}
    @indicators.each do |a|
      a['motion']['vote_events'].each do |ve|
        wanted_votes = @filter.nil? ? ve['votes'] : ve['votes'].find_all(&@filter) 
        wanted_votes.group_by { |v|
          # Group by the first potential key that exists (e.g. mp or mp_id)
          # There must be a more rubyish way of doing this. 
          bloc = v[@groups.first { |g| v.key?(g) }]
          # Then collapse records to ID as other hash values may differ for
          # different votes (e.g. the MP's party)
          key = bloc.is_a?(Hash) ? bloc['id'] : bloc
        }.each do |key, votes|
          ((scored_votes[key] ||= []) << _weighted_votes(votes, a['weights'])).flatten!
        end
      end
    end
    return scored_votes
  end

end

class Stancer::Score

  def initialize(scores)
    @scores = scores
  end

  def to_h
    return { 
      weight: weight,
      score: total_score,
      num_votes: num_votes,
      num_motions: num_motions,
      min: min_score,
      max: max_score,
      counts: counts,
    }
  end

  def total_score 
    @scores.map { |a| a[:score] }.inject(:+) 
  end

  def num_motions 
    @scores.count 
  end

  # Number of votes actually cast: 
  #   if this is zero = "Never voted on X" rather than
  #   "Always abstained on X"
  # TODO: this version is UK specific, and should be configurable
  def num_votes 
    @scores.reject { |a| a[:option] == 'absent' }.count
  end

  def min_score
    @scores.map { |a| a[:min] }.inject(:+) 
  end

  def max_score
    @scores.map { |a| a[:max] }.inject(:+) 
  end

  def counts 
    @scores.group_by { |a| a[:option] }.map { |o,ss| { option: o, value: ss.count } } 
  end

  # TODO this only works when vote ranges are 0..max
  # FIXME for negatives, or other ranges, by calculating with min_score too
  def weight
    num_motions.zero? ? 0.5 : total_score.fdiv(max_score)
  end
    
end

