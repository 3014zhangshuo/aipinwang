class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_mailbox
  before_action :get_conversation, except: [:index,:empty_trash]

  def index
     if params[:box].eql? "inbox"
       @conversations = @mailbox.inbox
     elsif params[:box].eql? "sent"
       @conversations = @mailbox.sentbox
     else
       @conversations = @mailbox.trash
     end
     @conversations = @conversations.page(params[:page])
   end


  def show
  end

  def reply
    current_user.reply_to_conversation(@conversation, params[:body])
    flash[:success] = '您的回信已出发'
    redirect_to conversation_path(@conversation)
  end

  def destroy
    @conversation.move_to_trash(current_user)
    flash[:success] = '这个对话已经被丢进垃圾桶了'
    redirect_to conversations_path
  end

  def empty_trash
    @mailbox.trash.each do |conversation|
      conversation.receipts_for(current_user).update_all(deleted: true)
    end
    flash[:success] = '垃圾桶已经被清空'
    redirect_to conversations_path
  end

  def restore
    @conversation.untrash(current_user)
    flash[:success] = '对话被还原'
    redirect_to conversations_path
  end

  def mark_as_read
    @conversation.mark_as_read(current_user)
    flash[:success] = '对话标记为已读'
    redirect_to conversations_path
  end

  private

    def get_mailbox
      @mailbox ||= current_user.mailbox
    end

    def get_conversation
      @conversation ||= @mailbox.conversations.find(params[:id])
    end

end
