require "spec_helper"

RSpec.describe RSpec::Perftest do
  include RSpec::Perftest

  let!(:randoms) { Array.new(1000) { rand } }

  step "loop-1000" do
    1000.times do
      randoms.inject(&:+)
    end
  end

  step "loop-10000" do
    10000.times do
      randoms.inject(&:+)
    end
  end
end
