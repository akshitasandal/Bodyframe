# class WorkoutPolicy
#     attr_reader :user, :workout
  
#     def initialize(user, workout)
#       @user = user
#       @workout = workout
#     end
  
#     def index?
#     #   @user.admin?
#     end

#     def show?
#       index?
#     end
  
#     def create?
#       index?
#     end
  
#     def update?
#       index?
#     end

#     def destroy?
#         index?
#     end
  
#     class Scope
#       attr_reader :user, :scope
  
#       def initialize(user, scope)
#         @user = user
#         @scope = scope
#       end
  
#       def resolve
#         scope.all
#       end
#     end
#   end
  