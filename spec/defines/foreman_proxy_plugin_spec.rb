require 'spec_helper'

describe 'foreman_proxy::plugin' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:title) { 'myplugin' }
      let(:pre_condition) { 'include foreman_proxy::params' }

      context 'no parameters' do
        package = if facts[:osfamily] == 'Debian'
                    'ruby-smart-proxy-myplugin'
                  elsif facts[:osfamily] == 'RedHat' && facts[:operatingsystemmajrelease] == '7'
                    'tfm-rubygem-smart_proxy_myplugin'
                  else
                    'rubygem-smart_proxy_myplugin'
                  end

        it 'should install the correct package' do
          should contain_package(package).with_ensure('installed')
        end
      end

      context 'with package parameter' do
        let :params do {
          :package => 'myplugin',
        } end

        it 'should install the correct package' do
          should contain_package('myplugin').with_ensure('installed')
        end
      end

      context 'with version parameter' do
        let :params do {
          :package => 'myplugin',
          :version => 'latest',
        } end

        it 'should install the correct package' do
          should contain_package('myplugin').with_ensure('latest')
        end
      end

      context 'when handling underscores on Red Hat' do
        let :params do {
          :package => 'my_fun_plugin',
        } end

        case facts[:osfamily]
        when 'Debian'
          it 'should use hyphens' do
            should contain_package('my-fun-plugin').with_ensure('installed')
          end
        else
          it 'should use underscores' do
            should contain_package('my_fun_plugin').with_ensure('installed')
          end
        end
      end
    end
  end
end
