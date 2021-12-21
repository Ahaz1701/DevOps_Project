# Redis

describe port(6379) do
    it { should be_listening }
end
  
describe process("redis-server") do
    it { should be_running }
end

# Server app

describe port(3000) do
    it { should be_listening }
end
