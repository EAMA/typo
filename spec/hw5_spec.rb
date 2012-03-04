describe 'the merge article should contain the text of both previous article' do
   before :each do
     @article = Factory(:article, :allow_comments => '1',
	:body_and_extended => 'my draft in autosave',
	:keywords => 'mientag',
	:permalink => 'big-post1',
	:title => 'Big Post1',
	:text_filter => 'none',
	:published => '1',
	:published_at => 'December 23, 2009 03:20 PM')
     @article2 = Factory(:article, :allow_comments => '1',
	:body_and_extended => 'Good Morning',
	:keywords => 'mientag',
	:permalink => 'big-post2',
	:title => 'Big Post2',
	:text_filter => 'none',
	:published => '1',
	:published_at = 'December 24, 2010, 03:40 PM'}
     Profile.delete_all
     @user = Factory(:user, :profile => Factory(:profile_admin, :label => Profile::ADMIN))
     @user.editor = 'simple'
     @user.save
     request.session = {:user => @user.id}
   end
   
   it 'should merge the article and the content should be merged' do
   	 @article.should_receive(:merge).with(@article2.id)
	 post :mergeArticle, 'id' => @article2.id
	 @article.body.should == 'my draft in autosave Good Morning'
	 @article.title.should == 'Big Post1'
	 @article.permalink.should == 'big-post1'
   end	
end


describe 'the merged article should have multiple authors' do
end

describe 'original article authors are able to edit the merged articles' do
	@article.should_receive(:merge).with(@article2.id)
	post :mergeArticle, 'id' => @article2.id
	@article.body.should == 'mydraft in autosave Good Morning'
	get :edit, 'id' => @article.id
	response.should render_template('new')
	assign(:article).should_not_be_null
	assign(:article).should be_valid
	response.should contain(/body/)
	response.should contain(/extended content/)
end

describe 'comments from both previous articles are carry over to the merged articles' do
end

#Add the has_many and belongs to relationship by rake db:migrate
