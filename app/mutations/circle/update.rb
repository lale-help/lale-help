class Circle::Update < Circle::BaseForm

  class Submit < Circle::BaseForm::Submit

    def execute
      super
    rescue ActiveRecord::RecordNotUnique => e
      handle_record_not_unique_exception(e)
      # must rollback the failed transaction manually, only then PG will continue normally on this connection.
      # "when Postgres raises an exception, it poisons future transactions on the same connection.
      # The fix is to rollback the offending transaction"
      # http://stackoverflow.com/a/31146267
      ActiveRecord::Base.connection.execute 'ROLLBACK'
    end

  end
end
