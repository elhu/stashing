require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe 'Logtastic' do
  describe '#store' do
    it "returns a new Hash for each key" do
      expect(Logtastic.store['a'].object_id).to_not be(Logtastic.store['b'].object_id)
    end

    it "returns the same Hash if called several time with the same key" do
      expect(Logtastic.store['a'].object_id).to be(Logtastic.store['a'].object_id)
    end
  end

  describe "#watch" do
    it "subscribes to the required event" do
      ActiveSupport::Notifications = double("Notifications")
      ActiveSupport::Notifications.should_receive(:subscribe).with('event_name')
      Logtastic.watch('event_name')
    end
  end
end
