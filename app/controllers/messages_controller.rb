class MessagesController < ApplicationController

  def admin
    user = User.default_admin

    @inbox_messages = user.inbox.messages
  end

  def doctor
    user = User.default_doctor

    @inbox_messages = user.inbox.messages
    @outbox_messages = user.outbox.messages
    @unreaded_messages ||= user.inbox.unread_messages_count
  end

  def index
    user = User.current

    @inbox_messages = user.inbox.messages
  end

  def show
    @message = Message.find(params[:id])
    Messages::ReadService.call(@message) unless @message.read
  end

  def new
    @message = Message.new
  end

  def create
    result = Messages::CreateService.call(
      user_id: message_params[:user_id],
      body: message_params[:body],
      original_message_id: message_params[:original_message_id]
    )

    if result.success?
      redirect_to root_path
    else
      error_response(result.message)
    end
  end

  def lost_script
    result = Messages::CreateService.call(
      user_id: message_params[:user_id],
      original_message_id: message_params[:original_message_id],
      lose_script: true
    )

    return error_response(result.message, true) if result.failure?
    payment = Payments::CreateService.call(
      user_id: message_params[:user_id]
    )

    if payment.success?
      render json: payment.payment, status: :created
    else
      error_response(payment.errors, true)
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :original_message_id, :user_id)
  end
end
