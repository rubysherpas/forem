shared_context "user migrations" do
  after do
    cleanup_migrations!
  end
  
  it "returns user class" do
    expect(subject.user_class).to eq(:users)
  end
end