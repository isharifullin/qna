shared_examples_for "publishable" do
  it 'publishes object' do
    expect(PrivatePub).to receive(:publish_to).with(chanel, anything)
    do_requset
  end
end