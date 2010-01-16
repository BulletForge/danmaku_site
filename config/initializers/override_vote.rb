Vote.class_eval do
  after_save :update_project_voting_counters
  
  private
  def update_project_voting_counters
    return unless self.votable.class.name == "Version"
    Project.transaction do
      p = self.votable.project
      p.update_attributes(:win_votes => p.calculate_win_votes, :fail_votes => p.calculate_fail_votes)
    end
    
  end
end