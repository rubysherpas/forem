shared_context "user migrations" do
  after do
    cleanup_migrations!
  end
  
  it "returns user class" do
    subject.user_class.should == :users
  end
end