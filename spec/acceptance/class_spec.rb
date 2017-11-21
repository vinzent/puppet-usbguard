require 'spec_helper_acceptance'

describe 'usbguard class' do
  context 'simple include' do
    let(:pp) do
      <<-EOS
        class { 'usbguard': }
      EOS
    end

    it_behaves_like 'a idempotent resource'

    describe package('usbguard') do
      it { is_expected.to be_installed }
    end

    describe file('/etc/usbguard/usbguard-daemon.conf') do
      its(:content) { is_expected.to match('Managed by puppet') }
    end

    describe file('/etc/usbguard/rules.conf') do
      it { is_expected.to be_file }
    end

    describe service('usbguard') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end

  context 'with some rules by param' do
    let(:pp) do
      <<-EOS
      $rule_content = @(CONTENT)
        allow with-interface equals { 08:*:* }
        reject with-interface all-of { 08:*:* 03:00:* }
        reject with-interface all-of { 08:*:* 03:01:* }
        reject with-interface all-of { 08:*:* e0:*:* }
        | CONTENT

      # DON'T DO THIS ON YOUR COMPUTER OR YOU MIGHT LOCK YOURSELF OUT
      # this is just an example. :-)
      class { 'usbguard':
        rules => [
          $rule_content,
          'reject with-interface all-of { 08:*:* 02:*:* }',
        ],
      }
      EOS
    end

    it_behaves_like 'a idempotent resource'

    describe file('/etc/usbguard/rules.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match('reject with-interface all-of { 08:\*:\* 03:00:\* }') }
    end
  end
end
