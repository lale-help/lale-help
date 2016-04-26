module FileUpload::Abilities
  def self.apply ability, user

    ability.can :read, FileUpload do |file|
      next true if file.is_public? && ability.can?(:read, file.uploadable)
      next true if ability.can?(:manage, file.uploadable)
      false
    end

  end
end