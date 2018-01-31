require 'spec_helper'

describe 'profile_development' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge({
            :concat_basedir => "/foo"
          })
        end

        context "profile_development class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('profile_development') }
          it { is_expected.to contain_class('profile_development::params') }
          it { is_expected.to contain_class('profile_development::install') }
          it { is_expected.to contain_class('profile_development::config') }
          it { is_expected.to contain_class('profile_development::service') }
          it { is_expected.to contain_class('ca_cert') }

          it { is_expected.to contain_file('kops_flags') }
          it { is_expected.to contain_file('kubectl_flags') }

          it { is_expected.to contain_remote_file('kops') }
          it { is_expected.to contain_remote_file('kubectl') }
          it { is_expected.to contain_remote_file('chrome') }
          it { is_expected.to contain_remote_file('chromedriver') }

          it { is_expected.to contain_Vcsrepo('/tmp/puppet-module-skeleton') }
          it { is_expected.to contain_Vcsrepo('/tmp/f5-ansible') }
          it { is_expected.to contain_Vcsrepo('/etc/ansible/f5-ansible_automation') }

          it { is_expected.to contain_exec('move org skeleton') }
          it { is_expected.to contain_exec('install skeleton') }
          it { is_expected.to contain_exec('install f5-ansible') }
          it { is_expected.to contain_exec('move org f5-ansible') }
          it { is_expected.to contain_exec('relybv') }
          it { is_expected.to contain_exec('unzip_chromedriver') }
          it { is_expected.to contain_exec('f5-ansible-requirements') }

          it { is_expected.to contain_Profile_development__Githuborg('relybv') }
          it { is_expected.to contain_Ca_cert__Ca('stack_rely_nl') }
          it { is_expected.to contain_Ssh_keygen('ubuntu') }

          case facts[:osfamily]
          when 'Debian'
            it { is_expected.to contain_apt__source('azurecli') }
            it { is_expected.to contain_apt__source('gcloud') }
            it { is_expected.to contain_apt__ppa('ppa:ansible/ansible') }
            it { is_expected.to contain_apt__ppa('ppa:brightbox/ruby-ng') }
            it { is_expected.to contain_user('ubuntu') }
            it { is_expected.to contain_package('ruby2.3') }
            it { is_expected.to contain_package('ruby2.3-dev') }
            it { is_expected.to contain_package('git') }
            it { is_expected.to contain_package('bundler') }
            it { is_expected.to contain_package('unzip') }
            it { is_expected.to contain_package('awscli') }
            it { is_expected.to contain_package('python-novaclient') }
            it { is_expected.to contain_package('python-neutronclient') }
            it { is_expected.to contain_package('python-glanceclient') }
            it { is_expected.to contain_package('software-properties-common') }
            it { is_expected.to contain_package('ansible') }
            it { is_expected.to contain_package('azure-cli') }
            it { is_expected.to contain_package('jq') }
            it { is_expected.to contain_package('google-cloud-sdk') }
            it { is_expected.to contain_package('python-pip') }
            it { is_expected.to contain_package('xvfb') }
            it { is_expected.to contain_package('chrome') }
            it { is_expected.to contain_package('selenium') }
            it { is_expected.to contain_package('gconf-service') }
            it { is_expected.to contain_package('libasound2') }
            it { is_expected.to contain_package('libatk1.0-0') }
            it { is_expected.to contain_package('libcairo2') }
            it { is_expected.to contain_package('libcups2') }
            it { is_expected.to contain_package('libfontconfig1') }
            it { is_expected.to contain_package('libgconf-2-4') }
            it { is_expected.to contain_package('libgdk-pixbuf2.0-0') }
            it { is_expected.to contain_package('libgtk-3-0') }
            it { is_expected.to contain_package('fonts-liberation') }
            it { is_expected.to contain_package('libappindicator1') }
            it { is_expected.to contain_package('libnspr4') }
            it { is_expected.to contain_package('libnss3') }
            it { is_expected.to contain_package('libxss1') }
            it { is_expected.to contain_package('xdg-utils') }
            it { is_expected.to contain_package('python-mysql.connector') }
            it { is_expected.to contain_package('rspec') }
            it { is_expected.to contain_package('selenium-webdriver') }
          end
        end
      end
    end
  end
end
