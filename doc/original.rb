require 'pp'

@domande = [{:phrase=>"Is it a reptile?", :yes=>1, :no=>2},
 {:phrase=>"Does it eat mosquitos?", :yes=>"geco", :no=>"lizard"},
 {:phrase=>"Does it make kittens?", :yes=>"cat", :no=>3},
 {:phrase=>"Does it have a pocket on the front?",
  :yes=>"kangaroo",
  :no=>"dog"}]

start_question = 0

def user_answer
  answer = gets
  if answer =~ /y/
    :yes
  else
    :no
  end
end

def check_answer( question_number, answer )
  choice = @domande[ question_number ][ answer ]
  if choice.is_a?( Numeric )
    ask_question( choice )
  else
    domanda = @domande[ question_number ]
    puts "I think it's a " + domanda[ answer ]
    puts "Is that correct?"

    is_correct = user_answer
    if is_correct == :yes
      puts "Yay, I got it right"
    else
      puts "What was the animal?"
      new_animal = gets.chomp
      puts "What question should I ask to know that it's a " + new_animal + " and not a " + domanda[ answer ] + "?"
      new_phrase = gets.chomp
      new_question = { :phrase => new_phrase,
                       :yes    => new_animal,
                       :no     => domanda[ answer ] }
      @domande << new_question
      new_index = @domande.size - 1
      @domande[ question_number ][ answer ] = new_index
    end  
  end
end

def ask_question( question_number )
  domanda = @domande[ question_number ]
  puts domanda[ :phrase ]

  answer = user_answer

  check_answer( question_number, answer )
end

while true do
  puts "Think of an animal..."
  ask_question( start_question )
  puts "Play again?"
  answer = user_answer
  break if answer == :no
  puts
end

pp @domande
