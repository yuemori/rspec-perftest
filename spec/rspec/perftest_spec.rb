require "spec_helper"

RSpec.describe RSpec::Perftest do
  include RSpec::Perftest

  step "sleep 0.5" do
    sleep 0.5
  end

  step "sleep 1" do
    sleep 1
  end
end
