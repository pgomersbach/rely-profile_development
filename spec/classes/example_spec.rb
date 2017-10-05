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

          it { is_expected.to contain_Vcsrepo('/tmp/puppet-module-skeleton') }
          it { is_expected.to contain_Vcsrepo('/tmp/f5-ansible') }

          it { is_expected.to contain_exec('move org skeleton') }
          it { is_expected.to contain_exec('install skeleton') }
          it { is_expected.to contain_exec('install f5-ansible') }
          it { is_expected.to contain_exec('move org f5-ansible') }
          it { is_expected.to contain_exec('relybv') }

          it { is_expected.to contain_Profile_development__Githuborg('relybv') }
          it { is_expected.to contain_Ca_cert__Ca('stack_rely_nl') }
          it { is_expected.to contain_Ssh_keygen('ubuntu') }

          case facts[:osfamily]
          when 'Debian'
            it { is_expected.to contain_apt__source('azurecli') }
            it { is_expected.to contain_apt__source('gcloud') }
            it { is_expected.to contain_apt__source('docker') }
            it { is_expected.to contain_apt__ppa('ppa:ansible/ansible') }
            it { is_expected.to contain_apt__ppa('ppa:brightbox/ruby-ng') }
            it { is_expected.to contain_apt__ppa('ppa:awstools-dev/awstools') }
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
            it { is_expected.to contain_package('docker.io') }
            it { is_expected.to contain_package('docker-compose') }
          end
        end
      end
    end
  end
end
