require "rspec"
require "rspec/its"
require 'flexyear'

describe FlexYear do
  before do
    allow(Date).to receive(:today) { Date.parse("2016-11-07") }
  end

  [FlexYear, FlexYear::Historical].each do |flexyear_class|
    context "given a blank string" do
      subject { flexyear_class.new("") }
      its(:year_low) { should be_nil }
      its(:year_high) { should be_nil }
    end

    context "given nil" do
      subject { flexyear_class.new(nil) }
      its(:year_low) { should be_nil }
      its(:year_high) { should be_nil }
    end

    context "text" do
      subject { flexyear_class.new("something") }
      its(:year_low) { should be_nil }
      its(:year_high) { should be_nil }
    end

    context "given 1979 as number" do
      subject { flexyear_class.new(1979) }
      its(:year_low) { should eq(1979) }
      its(:year_high) { should eq(1979) }
    end

    context "given 1979" do
      subject { flexyear_class.new("1979") }
      its(:year_low) { should eq(1979) }
      its(:year_high) { should eq(1979) }
    end

    context "given 1979 (with a space)" do
      subject { flexyear_class.new("1979 ") }
      its(:year_low) { should eq(1979) }
      its(:year_high) { should eq(1979) }
    end

    context 'given 197*' do
      subject { flexyear_class.new('197*') }
      its(:year_low) { should eq(1970) }
      its(:year_high) { should eq(1979) }
    end

    context "given 1970s" do
      subject { flexyear_class.new("1970s") }
      its(:year_low) { should eq(1970) }
      its(:year_high) { should eq(1979) }
    end

    context "given 70s" do
      subject { flexyear_class.new("70s") }
      its(:year_low) { should eq(1970) }
      its(:year_high) { should eq(1979) }
    end

    context "given something with negative and dots" do
      subject { flexyear_class.new("approx.-2006") }
      its(:year_low) { should eq(2005) }
      its(:year_high) { should eq(2007) }
    end

    context 'given before 1973' do
      subject { FlexYear.new('before 1973') }
      its(:year_low) { should be_nil }
      its(:year_high) { should eq(1973) }
    end

    context 'given after 1973' do
      subject { FlexYear.new('after 1973') }
      its(:year_low) { should eq(1973) }
      its(:year_high) { should be_nil }
    end

    ["mid 1970s", "mid 70s", "mid-70s", "mid-70's"].each do |year|
      context "given #{year}" do
        subject { flexyear_class.new(year) }
        its(:year_low) { should eq(1973) }
        its(:year_high) { should eq(1976) }
        its(:to_s) { should eq(year) }
      end
    end

    ["early 1970s", "early 70s", "early-70s", "early 70's"].each do |year|
      context "given #{year}" do
        subject { flexyear_class.new(year) }
        its(:year_low) { should eq(1970) }
        its(:year_high) { should eq(1973) }
      end
    end

    ["late 1970s", "late 70s", "late -70s", "late  70  s"].each do |year|
      context "given #{year}" do
        subject { flexyear_class.new(year) }
        its(:year_low) { should eq(1976) }
        its(:year_high) { should eq(1979) }
      end
    end

    ["73-75", "1973-1975", "1973 - 1975", "1973- 1975", "1973 -1975", "1973-75"].each do |range|
      context "given a range #{range}" do
        subject { flexyear_class.new(range) }
        its(:year_low) { should eq(1973) }
        its(:year_high) { should eq(1975) }
      end
    end

    context "given a range 1975-1973 (from high to low)" do
      subject { flexyear_class.new('1975-1973') }
      its(:year_low) { should eq(1973) }
      its(:year_high) { should eq(1975) }
    end

    context "given a range" do
      ["2003-4", "2003-04", "03-04"].each do |range|
        subject { flexyear_class.new(range) }
        its(:year_low) { should eq(2003) }
        its(:year_high) { should eq(2004) }
      end
    end

    context 'given a circa' do
      context 'at the end of the string' do
        subject { flexyear_class.new('1973 (Circa)') }
        its(:year_low) { should eq(1972) }
        its(:year_high) { should eq(1974) }
      end

      context 'at the beginning of the string' do
        subject { flexyear_class.new('Circa 1973') }
        its(:year_low) { should eq(1972) }
        its(:year_high) { should eq(1974) }
      end

      context 'abbreviated' do
        subject { flexyear_class.new('ca 1973') }
        its(:year_low) { should eq(1972) }
        its(:year_high) { should eq(1974) }
      end

      context 'with dots' do
        subject { flexyear_class.new('c.a. 1973') }
        its(:year_low) { should eq(1972) }
        its(:year_high) { should eq(1974) }
      end

      context 'with c.' do
        subject { flexyear_class.new('c. 1973') }
        its(:year_low) { should eq(1972) }
        its(:year_high) { should eq(1974) }
      end

      context 'with ca.' do
        subject { flexyear_class.new('ca. 1973') }
        its(:year_low) { should eq(1972) }
        its(:year_high) { should eq(1974) }
      end

      context 'with approx.' do
        subject { flexyear_class.new('approx. 1973') }
        its(:year_low) { should eq(1972) }
        its(:year_high) { should eq(1974) }
      end

      context 'with appxly.' do
        subject { flexyear_class.new('appxly 1973') }
        its(:year_low) { should eq(1972) }
        its(:year_high) { should eq(1974) }
      end

      context 'with around' do
        subject { flexyear_class.new('around 1973') }
        its(:year_low) { should eq(1972) }
        its(:year_high) { should eq(1974) }
      end

      context 'with about' do
        subject { flexyear_class.new('about 1973') }
        its(:year_low) { should eq(1972) }
        its(:year_high) { should eq(1974) }
      end

      context 'with circ' do
        subject { flexyear_class.new('circ. 1973') }
        its(:year_low) { should eq(1972) }
        its(:year_high) { should eq(1974) }
      end

      context 'with cca' do
        subject { flexyear_class.new('cca 1973') }
        its(:year_low) { should eq(1972) }
        its(:year_high) { should eq(1974) }
      end

      context 'given 2 character fields' do
        context "from previous century" do
          subject { flexyear_class.new("73") }
          its(:year_low) { should eq(1973) }
          its(:year_high) { should eq(1973) }
        end

        context "from current century" do
          subject { flexyear_class.new("06") }
          its(:year_low) { should eq(2006) }
          its(:year_high) { should eq(2006) }
        end
      end
    end

    context "given a list" do
      context "mixed years" do
        subject { flexyear_class.new(["1980s", "mid-80s", "1988 - 1999", 2001,]) }
        its(:year_low) { should eq(1980) }
        its(:year_high) { should eq(2001) }
      end

      context "same years" do
        subject { flexyear_class.new(["1988", "1988"]) }
        its(:year_low) { should eq(1988) }
        its(:year_high) { should eq(1988) }
      end

      context "mixed years with nil" do
        subject { flexyear_class.new(["1988", "1990s", nil]) }
        its(:year_low) { should eq(1988) }
        its(:year_high) { should eq(1999) }
      end
    end

    context "given 12345 (five digit year)" do
      specify do
        expect { flexyear_class.new('12345') }.to raise_error(FlexYear::InvalidYearError)
      end
    end

  end

  describe FlexYear::Historical do
    context "given a year past today" do
      specify do
        expect { FlexYear::Historical.new('3000') }.to raise_error(FlexYear::InvalidYearError)
      end
    end
  end

end
