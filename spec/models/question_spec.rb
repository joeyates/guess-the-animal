require 'spec_helper'

describe Question do

  fixtures :questions

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
        rat = Question.create!( :animal => 'Rat' )
        q = Question.create!( :phrase => 'Does it bark?', :yes => dog, :no => rat )

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
        rat = Question.create!( :animal => 'Rat' )
        q  = Question.create!( :phrase => 'Does it bark?', :yes => dog, :no => rat )

        q.no.should     == rat
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
        rat = Question.create!( :animal => 'Rat' )

        expect do
          Question.create!( :phrase => 'Not a question', :yes => dog, :no => rat )
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

  context '.root' do

    it 'should find the Question with the FIRST_PHRASE' do
      Question.root.phrase.    should     == Question::FIRST_PHRASE
    end

  end

  context '.unique_animal' do

    it 'should return a unique animal name' do
      name = Question.unique_animal

      Question.find_by_animal( name ).
                               should     be_nil
    end

    it 'should raise an error if all generable names exist' do
      Question.                should_receive( :find_by_animal ).
                               any_number_of_times.
                               and_return( 'x' )

      expect do
        Question.unique_animal
      end.                     to        raise_error( RuntimeError, /All generable names exist/ )
    end

  end

  context '#insert_question' do

    before :each do
      @q = Question.create!( :animal => 'Dog' )
    end

    it 'should succeed give valid data' do
      expect do
        @q.insert_question( 'Has it got horns?', 'Goat' )
      end.                    to_not     raise_error
    end

    it 'should trigger validation of phrase' do
      expect do
        @q.insert_question( 'Has it got horns', 'Goat' )
      end.                    should     raise_error( ActiveRecord::RecordInvalid,
                                                      /Phrase should be a question/ )
    end

    it 'should leave data unaltered on errors' do
      begin
        @q.insert_question( 'Has it got horns', 'Goat' )
      rescue ActiveRecord::RecordInvalid => e
        q = Question.find( @q.id )
        q.animal.             should     == 'Dog'
      end
    end

    it 'should make supplied #animal the #yes answer' do
      @q.insert_question( 'Has it got horns?', 'Goat' )

      @q.yes.animal.          should     == 'Goat'
    end

    it 'should move #animal to #no' do
      @q.insert_question( 'Has it got horns?', 'Goat' )

      @q.no.animal.           should     == 'Dog'
    end

    it 'should nullify #animal' do
      @q.insert_question( 'Has it got horns?', 'Goat' )

      @q.animal.              should     be_nil
    end

  end

end
