require 'spec_helper'

describe Question do

  context 'associations' do

    context '#animal' do

      it 'should be settable' do
        expect do
          Question.create!( :animal => 'Foo' )
        end.                     to_not    raise_error
      end

    end

    context "#yes" do

      it 'should be settable' do
        dog = Question.create!( :animal => 'Dog' )
        cat = Question.create!( :animal => 'Cat' )
        q = Question.create!( :phrase => 'Does it bark?', :yes => dog, :no => cat )

        q.yes.should     == dog
      end

      it "is nullable" do
        q = Question.create!( :animal => 'Dog' )

        q.yes.should     be_nil
      end

    end

    context "#no" do

      it 'should be settable' do
        dog = Question.create!( :animal => 'Dog' )
        cat = Question.create!( :animal => 'Cat' )
        q  = Question.create!( :phrase => 'Does it bark?', :yes => dog, :no => cat )

        q.no.should     == cat
      end

      it "is nullable" do
        q = Question.create!( :animal => 'Dog' )

        q.no.should     be_nil
      end

    end

  end

  context 'validations' do

    context "#phrase" do

      it 'should be present, if animal is not' do
        expect do
          Question.create!
        end.                   to        raise_error( ActiveRecord::RecordInvalid,
                                                      /Animal and phrase can't both be blank/ )
      end

      it 'should be a question' do
        dog = Question.create!( :animal => 'Dog' )
        cat = Question.create!( :animal => 'Cat' )

        expect do
          Question.create!( :phrase => 'Not a question', :yes => dog, :no => cat )
        end.                   to        raise_error( ActiveRecord::RecordInvalid,
                                                      /Phrase should be a question/ )
      end

    end

    context '#animal' do

      it 'should be unique' do
        dog = Question.create!( :animal => 'Dog' )

        expect do
          Question.create!( :animal => 'Dog' )
        end.                   to        raise_error( ActiveRecord::RecordInvalid,
                                                      /Animal has already been added/ )
      end

    end

    context "#yes" do

      it "must only be set together with #no" do
        yes = Question.create!( :animal => 'Dog' )
        q = Question.new( :phrase => 'Does it bark?' )
        q.yes = yes

        expect do
          q.save!
        end.                   to        raise_error( ActiveRecord::RecordInvalid,
                                                      /No should be set if yes is set/ )
      end

      it 'should be different to the #no' do
        q1 = Question.create!( :animal => 'Dog' )
        q = Question.new( :phrase => 'Does it bark?' )
        q.yes = q1
        q.no  = q1

        expect do
          q.save!
        end.                   to        raise_error( ActiveRecord::RecordInvalid,
                                                      /Yes should be different to no/ )
      end

    end

    context "#no" do

      it "must only be set together with #yes" do
        no = Question.create!( :animal => 'Dog' )
        q = Question.new( :phrase => 'Does it bark?' )
        q.no = no

        expect do
          q.save!
        end.                   to        raise_error( ActiveRecord::RecordInvalid,
                                                      /No should not be set if yes is not set/ )
      end

    end

  end

end
