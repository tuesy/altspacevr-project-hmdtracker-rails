require 'rails_helper'

describe Hmd do
  it "should default the state for new objects to the first state" do
    expect(Hmd.new.state).to eq(:announced)
  end

  it "should create a new HmdState object on Hmd creation" do
    expect{create(:hmd)}.to change(HmdState, :count).by(1)
  end

  context ".state" do
    it "should use the same default for hmd's with no history" do
      expect(create(:hmd).state).to eq(:announced)
    end

    it "should show the most recent state given there's one history" do
      x = create(:hmd, state: :devkit)
      expect(x.reload.state).to eq(:devkit)
    end

    it "should create multiple HmdState objects" do
      expect do
        x = create(:hmd, state: :devkit)
        x.state = :released
        x.save!
      end.to change(HmdState, :count).by(2)
    end

    it "should show the most recent state given there are multiple histories" do
      x = create(:hmd, state: :devkit)
      x.state = :released
      x.save!
      expect(x.reload.state).to eq(:released)
    end
  end

  context ".state=" do
    it "should create a new HmdState given a valid state" do
      expect do
        create(:hmd, state: :devkit)
      end.to change(HmdState, :count).by(1)
    end

    it "should work with strings too" do
      expect do
        create(:hmd, state: 'devkit')
      end.to change(HmdState, :count).by(1)
    end

    it "should raise an exception if state is invalid" do
      expect do
        create(:hmd, state: :invalid)
      end.to raise_error(RuntimeError)
    end
  end
end
