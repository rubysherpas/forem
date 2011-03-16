# "Borrowed" from the context engine
# We fake the login process in the engine, as we don't know how the actual
# application would have it set up. Guessing is best, currently.

# TODO: Consider moving to something like https://github.com/quickleft/abstract_auth
#       to make this easier to test.

def sign_out!
  Forem::ApplicationController.class_eval <<-STRING
    def current_user
      nil
    end

    helper_method :current_user
  STRING
end

def sign_in!(options={})
  # Fake user, provided by our fake "model".
  # HACK HACK HACK.
  # This is done so we can use the options to define how the current_user method is defined.
  # Better ideas?
  Forem::ApplicationController.class_eval <<-STRING
    def current_user
      attributes = { :login => "forem_user" }
      #{"attributes.merge!(:forem_admin => true)" if options[:admin]}

      user = User.new(attributes)
      user.id = 1
      user
    end

    helper_method :current_user
  STRING
end
