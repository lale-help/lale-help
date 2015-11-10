require 'rails_helper'

describe Circle::TasksController, :skip , type: :controller do
  let(:volunteer){circle.admin}
  let!(:task){FactoryGirl.create(:task)}
  let(:working_group){task.working_group}
  let(:circle){working_group.circle}

  # This should return the minimal set of attributes required to create a valid
  # Task. As you add validations to Task, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      name: "Task b",
      description: "d1",
      working_group_id: working_group.id,
      due_date: 1.day.from_now.strftime("%d %B %Y")
    }
  }

  let(:invalid_attributes) {
    {
        name: nil,
        description: "d1",
        working_group_id: working_group.id
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TasksController. Be sure to keep this updated too.
  let(:valid_session) { { user_id: volunteer.id } }
  let(:valid_url_args) { { circle_id: circle.id} }

  describe "GET #index" do
    it "assigns all tasks as @tasks" do
      get :index, valid_url_args, valid_session
      expect(assigns(:tasks)).to eq(OpenStruct.new(open: [task], closed: []))
    end
  end

  describe "GET #new" do
    it "assigns a new task as @task" do
      get :new, valid_url_args, valid_session
      expect(assigns(:task)).to be_a_new(Task)
    end
  end

  describe "GET #edit" do
    it "assigns the requested task as @task" do
      get :edit, valid_url_args.merge({:id => task.to_param}), valid_session
      expect(assigns(:task)).to eq(task)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Task" do
        expect {
          post :create, valid_url_args.merge({:task => valid_attributes}), valid_session
        }.to change(Task, :count).by(1)
      end

      it "assigns a newly created task as @task" do
        post :create, valid_url_args.merge({:task => valid_attributes}), valid_session
        expect(assigns(:task)).to be_a(Task)
        expect(assigns(:task)).to be_persisted
      end

      it "redirects to the created task" do
        post :create, valid_url_args.merge({:task => valid_attributes}), valid_session
        expect(response).to redirect_to(circle_task_path(circle, assigns(:task)))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved task as @task" do
        post :create, valid_url_args.merge({:task => invalid_attributes}), valid_session
        expect(assigns(:task)).to be_a_new(Task)
      end

      it "re-renders the 'new' template" do
        post :create, valid_url_args.merge({:task => invalid_attributes}), valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {name: "Fooo"}
      }

      it "updates the requested task" do
        put :update, valid_url_args.merge({:id => task.to_param, :task => new_attributes}), valid_session
        task.reload
        expect(task.name).to eq("Fooo")
      end

      it "assigns the requested task as @task" do
        put :update, valid_url_args.merge({:id => task.to_param, :task => valid_attributes}), valid_session
        expect(assigns(:task)).to eq(task)
      end

      it "redirects to the task" do
        put :update, valid_url_args.merge({:id => task.to_param, :task => valid_attributes}), valid_session
        expect(response).to redirect_to(circle_task_path(circle, task))
      end
    end

    context "with invalid params" do
      it "assigns the task as @task" do
        put :update, valid_url_args.merge({:id => task.to_param, :task => invalid_attributes}), valid_session
        expect(assigns(:task)).to eq(task)
      end

      it "re-renders the 'edit' template" do
        put :update, valid_url_args.merge({:id => task.to_param, :task => invalid_attributes}), valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested task" do
      expect {
        delete :destroy, valid_url_args.merge({:id => task.to_param}), valid_session
      }.to change(Task, :count).by(-1)
    end

    it "redirects to the tasks list" do
      delete :destroy, valid_url_args.merge({:id => task.to_param}), valid_session
      expect(response).to redirect_to(circle_tasks_path(circle))
    end
  end

  describe "PUT #volunteer" do
    it 'volunteers the current user for the task' do
      put :volunteer, valid_url_args.merge({:task_id => task.to_param}), valid_session
      task.reload
      expect(task.volunteers).to include(volunteer)
    end
  end

  describe "PUT #complete" do
    it 'marks a task complete' do
      task.volunteers << volunteer
      task.save
      put :complete, valid_url_args.merge({:task_id => task.to_param}), valid_session
      task.reload
      expect(task.complete?).to be true
    end
  end
end
