require 'spec_helper_acceptance'

describe 'usbguard::rule defined type' do
  context 'with a rule (single line)' do
    let(:pp) do
      <<-EOS
        class { 'usbguard': }
        usbguard::rule { 'allow with-interface equals { 08:*:* }': }
      EOS
    end

    it_behaves_like 'a idempotent resource'
    describe file('/etc/usbguard/rules.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(%r{allow with-interface equals \{ 08:\*:\* \}}) }
    end
  end

  context 'with a rule (multi line)' do
    let(:pp) do
      <<-EOS
      include ::usbguard

      $rule_content = @(CONTENT)
        allow with-interface equals { 08:*:* }
        reject with-interface all-of { 08:*:* 03:00:* }
        reject with-interface all-of { 08:*:* 03:01:* }
        reject with-interface all-of { 08:*:* e0:*:* }
        reject with-interface all-of { 08:*:* 02:*:* }
        | CONTENT

      # DON'T DO THIS ON YOUR COMPUTER OR YOU MIGHT LOCK YOU OUT
      # this is just an example. :-)
      usbguard::rule { 'allow usb disks without keyboard interface':
        rule => $rule_content,
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
