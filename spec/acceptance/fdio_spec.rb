require 'spec_helper_acceptance'

describe 'fdio' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      class { '::fdio':
        repo_branch => 'release'
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('vpp') do
      it { should be_installed }
    end

    describe file('/etc/vpp/startup.conf') do
      it { is_expected.to exist }
    end

    describe service('vpp') do
      it { should be_running }
      it { should be_enabled }
    end

  end

  context 'with options' do
    it 'should work with no errors' do
      pp= <<-EOS
      class { '::fdio':
        repo_branch => 'release',
        vpp_cpu_main_core => '1',
        vpp_cpu_corelist_workers => '2',
        vpp_vhostuser_coalesce_frames => 32,
        vpp_vhostuser_coalesce_time => 0.05,
        vpp_vhostuser_dont_dump_memory => true,
        vpp_tuntap_enable => true,
        vpp_tuntap_mtu => 9000,
        vpp_tapcli_mtu => 8000,
        vpp_exec_commands => 'test line 1',
        vpp_exec_file => '/etc/vpp/vpp-exec'
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/vpp/startup.conf') do
      its(:content) { should match /main-core\s+1/ }
      its(:content) { should match /corelist-workers\s+2/ }
      its(:content) { should match /coalesce-frames\s+32/ }
      its(:content) { should match /coalesce-time\s+0.05/ }
      its(:content) { should match /dont-dump-memory/ }
      its(:content) { should match /enable/ }
      its(:content) { should match /mtu 9000/ }
      its(:content) { should match /mtu 8000/ }
      its(:content) { should match /\/etc\/vpp\/vpp-exec/ }
    end

    describe file('/etc/vpp/vpp-exec') do
      its(:content) { should match /test line 1/ }
    end
  end
end
