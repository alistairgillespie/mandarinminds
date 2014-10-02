class TeachersController < ApplicationController
  def update
    @teacher = Teacher.find(params[:id])
    
    if @teacher.update(teacher_params)
        redirect_to teachers_path, notice: 'Teacher was successfully updated.'
      else
        redirect_to teachers_path, notice: "An error occured. The teacher must have an abbreviated name, and it musn't have any spaces in it"
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = Teacher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teacher_params
      #params[:user]
      params.require(:teacher).permit(:user_id, :show_in_dropdown, :show_on_page, :description, :abbr)

    end
end