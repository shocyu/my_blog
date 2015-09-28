class MicropostsController < ApplicationController
  before_action :authenticate_user!

  # 記事一覧
  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @microposts = @user.entries
    else
      @microposts = Micropost.all
    end
    @microposts = @microposts.readable_for(current_user)
      .order(posted_at: :desc).paginate(page: params[:page], per_page: 5)
  end
  
  # 記事詳細
  def show
    @micropost = Micropost.readable_for(current_user).find(params[:id])
  end
  
  # 新規登録フォーム
  def new
    @micropost = Micropost.new(posted_at: Time.current)
  end

  # 編集フォーム
  def edit
    @micropost = current_user.microposts.find(params[:id])
  end

  # 新規作成
  def create
    @micropost = Micropost.new(micropost_params)
    @micropost.user = current_user
    if @micropost.save
      redirect_to @micropost, notice: "記事を作成しました。"
    else
      render "new"
    end
  end

  # 更新
  def update
    @micropost = current_member.microposts.find(params[:id])
    @micropost.assign_attributes(micropost_params)
    if @entry.save
      redirect_to @micropost, notice: "記事を更新しました。"
    else
      render "edit"
    end
  end

  # 削除
  def destroy
    @micropost = current_user.microposts.find(params[:id])
    @micropost.destroy
    redirect_to :microposts, notice: "記事を削除しました。"
  end
  
   private

    def micropost_params
      params.require(:micropost).permit(:title, :content, :posted_at, :status)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end