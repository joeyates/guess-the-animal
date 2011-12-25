require 'spec_helper'

describe Question do

  context 'associations' do

    context "#yes_question" do

      it "may be set" do
        yes = Question.create!
        no  = Question.create!
        q = Question.create!( :yes_question => yes, :no_question => no )

        q.yes_question.should     == yes
      end

      it "is nullable" do
        q = Question.create!

        q.yes_question.should     be_nil
      end

    end

    context "#no_question" do

      it "may be set" do
        yes = Question.create!
        no  = Question.create!
        q  = Question.create!( :yes_question => yes, :no_question => no )

        q.no_question.should     == no
      end

      it "is nullable" do
        q = Question.create!

        q.no_question.should     be_nil
      end

    end

  end

  context 'validations' do

    context "#yes_question" do

      it "must only be set together with no_question" do
        yes = Question.create!
        q = Question.new
        q.yes_question = yes

        expect do
          q.save!
        end.                   to        raise_error( ActiveRecord::RecordInvalid,
                                                      /No question should be set if yes_question is set/ )
      end

      it 'should be different to the no question' do
        q1 = Question.create!
        q = Question.new
        q.yes_question = q1
        q.no_question  = q1

        expect do
          q.save!
        end.                   to        raise_error( ActiveRecord::RecordInvalid,
                                                      /Yes question should be different to no_question, No question should be different to yes_question/ )
      end

    end

    context "#no_question" do

      it "must only be set together with yes_question" do
        no = Question.create!
        q = Question.new
        q.no_question = no

        expect do
          q.save!
        end.                   to        raise_error( ActiveRecord::RecordInvalid,
                                                      /No question should not be set if yes_question is not set/ )
      end

    end

  end

end
