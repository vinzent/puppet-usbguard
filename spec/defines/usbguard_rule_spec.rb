require 'spec_helper'

describe 'usbguard::rule' do
  let(:pre_condition) { 'include usbguard' }
  let(:title) { 'allow with-interface equals { 08:*:* }' }

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
