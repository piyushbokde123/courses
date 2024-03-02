class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    
    if user.role == 'admin'
      can :manage, :all
    elsif user.role == 'instructor'
      can :manage, Course, instructor_id: user.id
      can :read, Course
      can :read, Enrollment, course: { instructor_id: user.id }
    elsif user.role == 'student'
      can :read, Course
      can :read, Enrollment, student_id: user.id
      can :create, Enrollment
    else
      can :read, Course
    end
  end
end