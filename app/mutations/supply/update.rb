class Supply::Update < Supply::BaseForm
  class Submit < Supply::BaseForm::Submit
    def execute
      outcome = super
      create_updates_comment(outcome.changes)
      outcome.supply
    end

    private

    def create_updates_comment(changes)
      Task::Comments::Updated.run!(task: supply, user: user, changes: changes)
    end

  end
end
