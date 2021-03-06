require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe 'Stashing' do
  describe '#store' do
    it "returns a new Hash for each key" do
      expect(Stashing.stash['a'].object_id).to_not be(Stashing.stash['b'].object_id)
    end

    it "returns the same stash if called several time with the same key" do
      expect(Stashing.stash['a'].object_id).to be(Stashing.stash['a'].object_id)
    end
  end

  describe "#watch" do
    it "subscribes to the required event" do
      ActiveSupport::Notifications.should_receive(:subscribe).with('event_name')
      Stashing.watch('event_name')
    end

    it "never raises an exception" do
      Stashing.watch('event_name') do
        1 / 0
      end
      expect {
        ActiveSupport::Notifications.instrument "event_name", this: :data do
          "test"
        end
      }.to_not raise_error
    end
  end
end
