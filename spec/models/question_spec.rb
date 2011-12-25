require 'spec_helper'

describe Question do

  context 'associations' do

    context "#yes_question" do

      it "may be set" do
        yes = Question.create!( :phrase => 'Foo' )
        no  = Question.create!( :phrase => 'Bar' )
        q = Question.create!( :phrase => 'Foo', :yes_question => yes, :no_question => no )

        q.yes_question.should     == yes
      end

      it "is nullable" do
        q = Question.create!( :phrase => 'Foo' )

        q.yes_question.should     be_nil
      end

    end

    context "#no_question" do

      it "may be set" do
        yes = Question.create!( :phrase => 'Foo' )
        no  = Question.create!( :phrase => 'Bar' )
        q  = Question.create!( :phrase => 'Foo', :yes_question => yes, :no_question => no )

        q.no_question.should     == no
      end

      it "is nullable" do
        q = Question.create!( :phrase => 'Foo' )

        q.no_question.should     be_nil
      end

    end

  end

  context 'validations' do

    context "#phrase" do

      it 'should be present' do
        expect do
          Question.create!
        end.                   to        raise_error( ActiveRecord::RecordInvalid,
                                                      /Phrase can't be blank/ )
      end

    end

    context "#yes_question" do

      it "must only be set together with #no_question" do
        yes = Question.create!( :phrase => 'Foo' )
        q = Question.new( :phrase => 'Foo' )
        q.yes_question = yes

        expect do
          q.save!
        end.                   to        raise_error( ActiveRecord::RecordInvalid,
                                                      /No question should be set if yes question is set/ )
      end

      it 'should be different to the #no_question' do
        q1 = Question.create!( :phrase => 'Foo' )
        q = Question.new( :phrase => 'Foo' )
        q.yes_question = q1
        q.no_question  = q1

        expect do
          q.save!
        end.                   to        raise_error( ActiveRecord::RecordInvalid,
                                                      /Yes question should be different to no question/ )
      end

      it 'should have different text #no_question' do
        yes = Question.create!( :phrase => 'Foo' )
        no  = Question.create!( :phrase => 'Foo' )
        q = Question.new( :phrase => 'Foo' )
        q.yes_question = yes
        q.no_question  = no

        expect do
          q.save!
        end.                   to        raise_error( ActiveRecord::RecordInvalid,
                                                      /Yes question should have different text to no question/ )
      end

    end

    context "#no_question" do

      it "must only be set together with #yes_question" do
        no = Question.create!( :phrase => 'Foo' )
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
