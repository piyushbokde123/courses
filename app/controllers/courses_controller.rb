class CoursesController < ApplicationController
  before_action :authenticate_user!, only: [:opt]

  def index
    @courses = Course.all
  end

  def new
   @course = Course.new
  end

  def create
    @course = current_user.courses.new(course_params)
    if @course.save
      redirect_to @course
    else
      render :new, status: :unprocessable_entity
    end

  end
  def show
    @course = Course.find(params[:id])
  end

  def opt
    @course = Course.find(params[:id])

    if current_user.student? && !current_user.courses.include?(@course)
      current_user.courses << @course
      redirect_to courses_path, notice: 'Course opted successfully!'
    else
      redirect_to @course, alert: 'Unable to opt for course.'
    end
  end

  private

   def course_params
      params.require(:course).permit(:name)
   end
end
