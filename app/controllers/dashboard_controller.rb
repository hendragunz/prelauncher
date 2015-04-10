class DashboardController < ApplicationController
    before_filter :authenticate_user!, only: [:refer, :top_list]

    def show
      return redirect_to user_refer_path if user_signed_in?

      @bodyId = 'home'
      @is_mobile = mobile_device?
    end

    def create
      # Get user to see if they have already signed up
      @user = User.find_by_email(params[:user][:email])

      # If user doesnt exist, make them, and attach referrer
      if @user.nil?

          cur_ip = IpAddress.find_by_address(request.env['HTTP_X_FORWARDED_FOR'])

          if !cur_ip
              cur_ip = IpAddress.create(
                  :address => request.env['HTTP_X_FORWARDED_FOR'],
                  :count => 0
              )
          end

          if cur_ip.count > 2
              return redirect_to root_path
          else
              cur_ip.count = cur_ip.count + 1
              cur_ip.save
          end

          @user = User.new(:email => params[:user][:email])

          @referred_by = User.find_by_referral_code(cookies[:h_ref])

          puts '------------'
          puts @referred_by.email if @referred_by
          puts params[:user][:email].inspect
          puts request.env['HTTP_X_FORWARDED_FOR'].inspect
          puts '------------'

          if !@referred_by.nil?
              @user.referrer = @referred_by
          end

          @user.save
        end

        # Send them over refer action
        respond_to do |format|
          if !@user.nil?
            cookies[:h_email] = { :value => @user.email }
            format.html { redirect_to '/refer-a-friend' }
          else
            format.html { redirect_to root_path, :alert => "Something went wrong!" }
          end
        end
    end

    def refer
      @bodyId = 'refer'
      @is_mobile = mobile_device?
      @user = current_user
    end


    # GET - user_top_path
    #
    def top_list
      @bodyId = 'refer'
      @is_mobile = mobile_device?

      @limit  = params[:limit] || '10'
      @gender = params[:gender]

      @users  = User.order("referrals_count DESC")

      if params[:gender].present?
        @users  = @users.where(gender: @gender)
      end

      @users  = @users.limit(@limit)
    end

    def policy

    end

    def redirect
        redirect_to root_path, :status => 404
    end

    # private

    # def skip_first_page
    #   if !Rails.application.config.ended
    #     cookies.delete :h_email
    #       email = cookies[:h_email]
    #       if email and User.find_by_email(email).present?
    #           redirect_to '/refer-a-friend'
    #       else
    #           cookies.delete :h_email
    #       end
    #   end
    # end

end
