require 'rails_helper'

describe 'custom matchers' do
  describe 'be_nil_or' do
    describe nil do
      it { is_expected.to be_nil_or(:<, 6) }
    end

    describe 5 do
      it { is_expected.to be_nil_or(:<, 6) }
    end

    describe 7 do
      it { is_expected.to_not be_nil_or(:<, 6) }
    end

    describe 1.week.ago do
      it { is_expected.to be_nil_or(:<, DateTime.now) }
    end
  end
end
