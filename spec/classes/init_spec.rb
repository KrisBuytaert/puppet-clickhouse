# frozen_string_literal: true

require 'spec_helper'

describe 'clickhouse' do
  context 'with defaults' do
    it { is_expected.to contain_class('clickhouse::client') }
    it { is_expected.not_to contain_class('clickhouse::server') }
  end

  context 'with server' do
    let(:params) { { server: true } }

    it { is_expected.to contain_class('clickhouse::client') }
    it { is_expected.to contain_class('clickhouse::server') }
  end

  context 'without client' do
    let(:params) { { server: true, client: false } }

    it { is_expected.not_to contain_class('clickhouse::client') }
    it { is_expected.to contain_class('clickhouse::server') }
  end

  context 'never manages the package repository (the consumer does)' do
    let(:params) { { server: true, client: true } }

    it { is_expected.not_to contain_class('clickhouse::repo') }
    it { is_expected.not_to contain_yumrepo('altinity_clickhouse') }
  end
end
