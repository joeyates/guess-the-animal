lizard = Question.create!( :animal => 'Lizard' )
cat    = Question.create!( :animal => 'Cat' )
Question.create!( :phrase => Question::FIRST_PHRASE, :yes => lizard, :no => cat )
