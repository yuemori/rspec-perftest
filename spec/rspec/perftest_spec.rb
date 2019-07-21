require "spec_helper"

RSpec.describe RSpec::Perftest do
  include RSpec::Perftest

  step "sleep" do
    sleep 1
  end
end
