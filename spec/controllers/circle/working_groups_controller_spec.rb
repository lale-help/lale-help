#
# FIXME these are outdated and are currently skipped in test runs. Either adapt them and enable, or remove them.
# 
# require 'rails_helper'

# describe Circle::WorkingGroupsController, :skip, type: :controller do


#   let(:volunteer) { circle.admin }
#   let(:circle)    { create(:circle) }
#   # This should return the minimal set of attributes required to create a valid
#   # WorkingGroup. As you add validations to WorkingGroup, be sure to
#   # adjust the attributes here as well.
#   let(:valid_attributes) {
#     {name: "Valid WG"}
#   }

#   let(:invalid_attributes) {
#     {name: nil}
#   }

#   let!(:working_group){circle.working_groups.create!(valid_attributes)}

#   # This should return the minimal set of values that should be in the session
#   # in order to pass any filters (e.g. authentication) defined in
#   # WorkingGroupsController. Be sure to keep this updated too.
#   let(:valid_session) { { user_id: volunteer.id } }
#   let(:valid_url_args) { { circle_id: circle.id} }

#   describe "GET #index" do
#     it "assigns all working_groups as @working_groups" do
#       get :index, valid_url_args, valid_session
#       expect(assigns(:working_groups)).to eq([working_group])
#     end
#   end

#   describe "GET #show" do
#     it "assigns the requested working_group as @working_group" do
#       get :show, valid_url_args.merge({:id => working_group.to_param}), valid_session
#       expect(assigns(:working_group)).to eq(working_group)
#     end
#   end

#   describe "GET #new" do
#     it "assigns a new working_group as @working_group" do
#       get :new, valid_url_args, valid_session
#       expect(assigns(:working_group)).to be_a_new(WorkingGroup)
#     end
#   end

#   describe "GET #edit" do
#     it "assigns the requested working_group as @working_group" do
#       get :edit, valid_url_args.merge({:id => working_group.to_param}), valid_session
#       expect(assigns(:working_group)).to eq(working_group)
#     end
#   end

#   describe "POST #create" do
#     context "with valid params" do
#       it "creates a new WorkingGroup" do
#         expect {
#           post :create, valid_url_args.merge({:working_group => valid_attributes}), valid_session
#         }.to change(WorkingGroup, :count).by(1)
#       end

#       it "assigns a newly created working_group as @working_group" do
#         post :create, valid_url_args.merge({:working_group => valid_attributes}), valid_session
#         expect(assigns(:working_group)).to be_a(WorkingGroup)
#         expect(assigns(:working_group)).to be_persisted
#       end

#       it "redirects to the created working_group" do
#         post :create, valid_url_args.merge({:working_group => valid_attributes}), valid_session
#         expect(response).to redirect_to(circle)
#       end
#     end

#     context "with invalid params" do
#       it "assigns a newly created but unsaved working_group as @working_group" do
#         post :create, valid_url_args.merge({:working_group => invalid_attributes}), valid_session
#         expect(assigns(:working_group)).to be_a_new(WorkingGroup)
#       end

#       it "re-renders the 'new' template" do
#         post :create, valid_url_args.merge({:working_group => invalid_attributes}), valid_session
#         expect(response).to render_template("new")
#       end
#     end
#   end

#   describe "PUT #update" do
#     context "with valid params" do
#       let(:new_attributes) {
#         {name: "Fooo"}
#       }

#       it "updates the requested working_group" do
#         put :update, valid_url_args.merge({:id => working_group.to_param, :working_group => new_attributes}), valid_session
#         working_group.reload
#         expect(working_group.name).to eq("Fooo")
#       end

#       it "assigns the requested working_group as @working_group" do
#         put :update, valid_url_args.merge({:id => working_group.to_param, :working_group => valid_attributes}), valid_session
#         expect(assigns(:working_group)).to eq(working_group)
#       end

#       it "redirects to the working_group" do
#         put :update, valid_url_args.merge({:id => working_group.to_param, :working_group => valid_attributes}), valid_session
#         expect(response).to redirect_to(circle)
#       end
#     end

#     context "with invalid params" do
#       it "assigns the working_group as @working_group" do
#         put :update, valid_url_args.merge({:id => working_group.to_param, :working_group => invalid_attributes}), valid_session
#         expect(assigns(:working_group)).to eq(working_group)
#       end

#       it "re-renders the 'edit' template" do
#         put :update, valid_url_args.merge({:id => working_group.to_param, :working_group => invalid_attributes}), valid_session
#         expect(response).to render_template("edit")
#       end
#     end
#   end

#   describe "DELETE #destroy" do
#     it "destroys the requested working_group" do
#       expect {
#         delete :destroy, valid_url_args.merge({:id => working_group.to_param}), valid_session
#       }.to change(WorkingGroup, :count).by(-1)
#     end

#     it "redirects to the working_groups list" do
#       delete :destroy, valid_url_args.merge({:id => working_group.to_param}), valid_session
#       expect(response).to redirect_to(circle)
#     end
#   end

# end
