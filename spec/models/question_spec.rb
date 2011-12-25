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

    context "#yes_question" do

      it 'should be settable' do
        yes = Question.create!( :animal => 'Dog' )
        no  = Question.create!( :animal => 'Cat' )
        q = Question.create!( :phrase => 'Foo', :yes_question => yes, :no_question => no )

        q.yes_question.should     == yes
      end

      it "is nullable" do
        q = Question.create!( :animal => 'Dog' )

        q.yes_question.should     be_nil
      end

    end

    context "#no_question" do

      it 'should be settable' do
        yes = Question.create!( :animal => 'Dog' )
        no  = Question.create!( :animal => 'Cat' )
        q  = Question.create!( :phrase => 'Foo', :yes_question => yes, :no_question => no )

        q.no_question.should     == no
      end

      it "is nullable" do
        q = Question.create!( :animal => 'Dog' )

        q.no_question.should     be_nil
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

    context "#yes_question" do

      it "must only be set together with #no_question" do
        yes = Question.create!( :animal => 'Dog' )
        q = Question.new( :phrase => 'Foo' )
        q.yes_question = yes

        expect do
          q.save!
        end.                   to        raise_error( ActiveRecord::RecordInvalid,
                                                      /No question should be set if yes question is set/ )
      end

      it 'should be different to the #no_question' do
        q1 = Question.create!( :animal => 'Dog' )
        q = Question.new( :phrase => 'Foo' )
        q.yes_question = q1
        q.no_question  = q1

        expect do
          q.save!
        end.                   to        raise_error( ActiveRecord::RecordInvalid,
                                                      /Yes question should be different to no question/ )
      end

    end

    context "#no_question" do

      it "must only be set together with #yes_question" do
        no = Question.create!( :animal => 'Dog' )
        q = Question.new( :phrase => 'Foo' )
        q.no_question = no

        expect do
          q.save!
        end.                   to        raise_error( ActiveRecord::RecordInvalid,
                                                      /No question should not be set if yes question is not set/ )
      end

    end

  end

end
